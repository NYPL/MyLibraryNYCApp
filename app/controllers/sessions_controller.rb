# frozen_string_literal: true

class SessionsController < Devise::SessionsController

  def create
    @user = User.find_by(email: session_params[:email])
    if @user
      login!
      render json: {
        logged_in: true,
        user: @user,
        user_return_to: session["user_return_to"] || 'teacher_set_data'
      }
    else
      render json: { 
        logged_in: false
      }
    end
  end

  def is_logged_in?
    if logged_in? && current_user
      render json: {
        logged_in: true,
        user: current_user
      }
    else
      render json: {
        logged_in: false,
        message: 'no such user'
      }
    end
  end

  def destroy
    logout!
    render json: {
      status: 200,
      logged_out: true
    }
  end


  private


  def session_params
    params.permit(:email)
  end


  def max_session_duration
    8.hours
  end


  def timeout_warning_duration
    10.minutes
  end


  def timeout_timestamp
    session["warden.user.user.session"]["last_request_at"] + max_session_duration
  end


  def timeout_warning_timestamp
    timeout_timestamp - timeout_warning_duration
  end
end
