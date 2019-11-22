# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  layout 'empty', :only => [ :timeout_check ]

  ## The user has just (re)logged in.  Reflect the time in the user's DB record.
  def create
    super
    current_user.last_sign_in_at = Time.zone.now
    current_user.save
  end


  ## Checks if the user's session has been timed out.
  # If yes, then gives a visual notification to the user.
  def timeout_check
    # session["warden.user.user.session"] comes from adding timeoutable to the user model
    # example: {"last_request_at"=>1537283353}
    if !session || !session["warden.user.user.session"]
      render json: { 'timeout_status': 'no_current_user' }, status: 100
    elsif session["warden.user.user.session"] && Time.zone.now.to_i > timeout_timestamp.to_i
      sign_out current_user
      flash[:notice] = "Your session has timed out."
      render json: { 'timeout_status': 'timed_out' }, status: 200
    elsif session["warden.user.user.session"] && Time.zone.now.to_i > timeout_warning_timestamp.to_i
      render json: { 'timeout_status': 'timeout_warning' }, status: 200
    else
      render json: { 'timeout_status': 'not_timed_out' }, status: 200
    end
  end

  private

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
