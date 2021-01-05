# frozen_string_literal: false

class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  include Exceptions
  include LogWrapper

  # When a user inputs information into the signup form, the data gets sent to the create method/action.
  # Currently we overide the devise create method to add some customization. The original method
  # can be found here https://github.com/plataformatec/devise/releases/tag/v3.5.1
  # The purpose for overriding the method was to add rescuing if the request to the microservice timed out.
  # In addition, overriding the method allows us to validate the incoming data from the form, send the data
  # to the microservice, and create a record on MyLibraryNYC depending on if the microservice is working properly.
  def create
    LogWrapper.log('INFO', {
      'method' => "RegistrationsController.create",
      'message' => "Creating new user record: start"
    })

    build_resource(sign_up_params)
    if resource.valid?
      begin
        # save the user object as pending
        resource.save_as_pending!

        puts "\n\nRegistrationsController.create: calling user.find_unique_new_barcode"
        # find fresh new barcode that's available in both MLN db and Sierra
        resource.find_unique_new_barcode
        puts "RegistrationsController.create: done user.find_unique_new_barcode"

        if params['news_letter_email'].present?
          # If User has alt_email in the signup page use alt_email for news-letter signup, other-wise user-email.
          email = user_params['alt_email'].present? ? user_params['alt_email'] : user_params['email']
          NewsLetterController.new.send_news_letter_confirmation_email(email)
        end

        yield resource if block_given?
        if resource.persisted?
          if resource.active_for_authentication?
            set_flash_message :notice, :signed_up if is_flashing_format?
            sign_up(resource_name, resource)
            respond_with resource, location: after_sign_up_path_for(resource)
          else
            set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
            expire_data_after_sign_in!
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords resource
          set_minimum_password_length
          respond_with resource
        end
      rescue Net::ReadTimeout => exception
        LogWrapper.log('ERROR', {
          'method' => "RegistrationsController.create",
          'message' => "Creating new patron threw a Net::ReadTimeout error: #{exception.message}, with backtrace: #{exception.backtrace.join('\n')}"
        })
        set_flash_message :notice, :time_out if is_flashing_format?
        render :template => '/devise/registrations/new'
      rescue StandardError => exception
        puts "reg: StdError1a: #{exception.message}"
        puts "reg: StdError1b: #{exception.backtrace.join('\n')}"
        LogWrapper.log('ERROR', {
          'method' => "RegistrationsController.create",
          'message' => "Creating new patron threw a StandardError: #{exception.message}, with backtrace: #{exception.backtrace.join('\n')}"
        })
        set_flash_message :notice, :time_out if is_flashing_format?
        render :template => '/devise/registrations/new'
      end
    else
      render :template => '/devise/registrations/new', :locals => { :error_msg_hash => error_msg_hash }
    end
  rescue Exceptions::InvalidResponse => exception
    LogWrapper.log('ERROR', {
      'method' => "RegistrationsController.create",
      'message' => "Creating new patron threw an Exceptions::InvalidResponse: #{exception.message}, with backtrace: #{exception.backtrace.join('\n')}"
    })
    set_flash_message :registration_error, :invalid_response if is_flashing_format?
    render :template => '/devise/registrations/new'
  end


  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    # Here Updates current user alt_email and schooid.
    current_user.alt_email = user_params["alt_email"] if user_params["alt_email"].present?
    current_user.school_id = user_params["school_id"] if user_params["school_id"].present?
    current_user.save!

    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end


  def after_update_path_for(resource)
    redirect_url = account_url
    if session[:redirect_after_update]
      redirect_url = session[:redirect_after_update]
      session.delete(:redirect_after_update)
    end
    redirect_url
  end


  # Below code for custom error messages.
  # Because Devise gem display same attributes from database.
  # eg: 'Pin does not meet our requirements. Please try again' instead of this error message
  # display  'PIN(here PIN is capital letters) does not meet our requirements. Please try again.'
  # Eg: resource.errors = @messages={:alt_email=>["has already been taken"], :pin=>["does not meet our requirements. Please try again."]}>
  def error_msg_hash
    error_msg_hash = {}
    if resource.errors.messages[:alt_email].present?
      error_msg_hash[:alt_email] = ['Alternate email '.concat("#{resource.errors.messages[:alt_email].join}.")]
    end

    if resource.errors.messages[:pin].present?
      error_msg_hash[:pin] = ['PIN '.concat(resource.errors.messages[:pin].join)]
    end

    if resource.errors.messages[:email].present?
      error_msg_hash[:email] = ['Email '.concat("#{resource.errors.messages[:email].join}.")]
    end
    error_msg_hash
  end

  private

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end


  def user_params
    params.require(:user).permit(:alt_email, :school_id, :email)
  end


  # Configure permitted parameters for devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :alt_email, :school_id, :pin])
  end
end
