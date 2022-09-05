# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    resource = User.new(user_params)
    begin
      patron_service = resource.send_request_to_patron_creator_service
      if resource.valid?
        if patron_service
          resource.save!
          sign_up :user, resource, bypass: true
          if params.require(:registration)["user"]['news_letter_email'].present?
            # If User has alt_email in the signup page use alt_email for news-letter signup, other-wise user-email.
            email = user_params['alt_email'].present? ? user_params['alt_email'] : user_params['email']
            NewsLetterController.new.send_news_letter_confirmation_email(email)
          end
          render json: { status: :created, user: resource, message: "Welcome! You have signed up successfully." }
        else
          render json: { status: 500 }
        end
      else
        render json: { status: 500,  message: error_msg_hash(resource) }
      end
    rescue Exceptions::InvalidResponse, StandardError => e
      render json: { status: 500, message: {error: [e.message]} }
    end
  end


  def update
    # Here Updates current user alt_email and schooid.
    current_user.alt_email = user_params["alt_email"] if user_params["alt_email"].present? 
    current_user.school_id = user_params["school_id"] if user_params["school_id"].present?
    current_user.save!

    if current_user.save!
      render json: { status: :updated, user: current_user, message: "Your account has been updated." }
    else
      render json: { message: error_msg_hash(current_user) }
    end
  end

  def new
    @user = User.new
  end

  # Below code for custom error messages. 
  # Because Devise gem display same attributes from database.
  # eg: 'Pin does not meet our requirements. Please try again' instead of this error message
  # display  'PIN(here PIN is capital letters) does not meet our requirements. Please try again.'
  # Eg: resource.errors = @messages={:alt_email=>["has already been taken"], :pin=>["does not meet our requirements. Please try again."]}>
  def error_msg_hash(user)
    error_msg_hash = {}
    if user.errors.messages[:alt_email].present?
      error_msg_hash[:alt_email] = ['Alternate email '.concat("#{user.errors.messages[:alt_email].join}.")]
    end

    if user.errors.messages[:email].present?
      error_msg_hash[:email] = ['Email '.concat("#{user.errors.messages[:email].join}.")]
    end
    error_msg_hash
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private
  
  def user_params
    params.require(:registration)["user"].permit(:alt_email, :school_id, :email, :first_name, :last_name, :password)
  end
end
