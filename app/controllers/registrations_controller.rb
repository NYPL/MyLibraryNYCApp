class RegistrationsController < Devise::RegistrationsController
  include Exceptions
  include LogWrapper

  # When a user inputs information into the signup form, the data gets sent to the create method/action.
  # Currently we overide the devise create method to add some customization. The original method
  # can be found here https://github.com/plataformatec/devise/releases/tag/v3.5.1
  # The purpose for overriding the method was to add rescuing if the request to the microservice timed out.
  # In addition, overriding the method allows us to validate the incoming data from the form, send the data
  # to the microservice, and create a record on MyLibraryNYC depending on if the microservice is working properly.
  def create
    LogWrapper.log('INFO','message' => "Creating new user record")
    build_resource(sign_up_params)
    if resource.valid?
      begin
        resource.send_request_to_patron_creator_service
        resource.save
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
      rescue Net::ReadTimeout
        set_flash_message :notice, :time_out if is_flashing_format?
        render :template => '/devise/registrations/new'
      end
    else
      render :template => '/devise/registrations/new', :locals => { :error_msg_hash => error_msg_hash }
    end
  rescue Exceptions::InvalidResponse
    set_flash_message :registration_error, :invalid_response if is_flashing_format?
    render :template => '/devise/registrations/new'
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
      error_msg_hash[:alt_email] = ['Alternate email '.concat(resource.errors.messages[:alt_email].join)]
    end

    if resource.errors.messages[:pin].present?
      error_msg_hash[:pin] = ['PIN '.concat(resource.errors.messages[:pin].join)]
    end

    if resource.errors.messages[:email].present?
      error_msg_hash[:email] = ['Email '.concat(resource.errors.messages[:email].join)]
    end
    error_msg_hash
  end
end

