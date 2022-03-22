# frozen_string_literal: false

class RegistrationsController <  ApplicationController 

  include Exceptions
  include LogWrapper

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    # Here Updates current user alt_email and schooid.
    current_user.alt_email = user_params["alt_email"] if user_params["alt_email"].present? 
    current_user.school_id = user_params["school_id"] if user_params["school_id"].present?
    current_user.save!

    if current_user.save!
      render json: { status: :updated, user: current_user, message: "You updated your account successfully." }
    else
      render json: { message: error_msg_hash(current_user) }
    end
  end


  def new
    @user = User.new
  end
  

  def create
    user = User.new(user_params)
    begin
      patron_service = user.send_request_to_patron_creator_service
      if user.valid?
        if patron_service
          user.save!
          # stores saved user id in a session
          session[:user_id] = user.id
          if params.require(:registration)["user"]['news_letter_email'].present?
            # If User has alt_email in the signup page use alt_email for news-letter signup, other-wise user-email.
            email = user_params['alt_email'].present? ? user_params['alt_email'] : user_params['email']
            NewsLetterController.new.send_news_letter_confirmation_email(email)
          end
          render json: { status: :created, user: user, message: "Welcome! You have signed up successfully." }
        else
          render json: { status: 500 }
        end
      else
        render json: { status: 500,  message: error_msg_hash(user) }
      end
    rescue Exceptions::InvalidResponse, StandardError => e
      render json: { status: 500, message: {error: [e.message]} }
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

  private
  
  def user_params
    params.require(:registration)["user"].permit(:alt_email, :school_id, :email, :first_name, :last_name, :password)
  end

end

