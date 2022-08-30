# frozen_string_literal: true

class SessionsController < ApplicationController

  def is_logged_in?
    if user_signed_in? && current_user
      LogWrapper.log('INFO', {'message' => 'is_logged_in',
                             'method' => "is_logged_in........ "})
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
