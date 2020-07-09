# frozen_string_literal: false

class ApplicationController < ActionController::Base
  protect_from_forgery


  def append_info_to_payload(payload)
    super
    if ActiveRecord::Base.connected? && payload[:status].present?
      payload[:host] = request.host
      case payload[:status]
      when 200
        payload[:level] = "INFO"
      when payload[:status]  > 200 && payload[:status]  < 400
        payload[:level] = "DEBUG"
      when payload[:status]  > 400
        payload[:level] = "WARNING"
      when payload[:status]  >= 500
        payload[:level] = "ERROR"
      end
    end
  end


  ##
  # Decides where to take the user who has just successfully logged in.
  def after_sign_in_path_for(resource)
    LogWrapper.log('DEBUG', {'message' => 'after_sign_in_path_for.start',
                             'method' => 'app/controllers/application_controller.rb.after_sign_in_path_for'})
    # be careful -- after first access stored_location_for clears to a nil, so read it once
    # and store it in a local var before printing out or any other access
    redirect_url = stored_location_for(:user)
    unless redirect_url.present?
      redirect_url = app_url
    end

    # Redirect to admin dashboard if this is an admin login
    # Commenting this out due to inconsistency when demo-ing with account that are admins
    # (PB: Uncommenting this out because I can't find a login flow that it effects. I think observed issue may have been something else..)
    redirect_url = admin_dashboard_path if !resource.nil? && resource.is_a?(AdminUser)

    # if session[:redirect_after_login]
    #   redirect_url = session[:redirect_after_login]
    #   session.delete(:redirect_after_login)
    # end

    redirect_url
  end


  # Is called by functionality that needs to make sure the user is authenticated,
  # s.a. making a teacher set order.  Takes the user to a login page.
  def require_login
    unless user_signed_in?
      flash[:error] = "Please sign in to complete your order!"
      respond_to do |format|
        format.html {
          # 2019-08-08: I think this is now ignored.  Commenting out for now, until make sure.
          # session[:redirect_after_login] = request.original_url
          redirect_to new_user_session_path
        }
        format.json {
          # 2019-08-08: I think this is now ignored.  Commenting out for now, until make sure.
          # session[:redirect_after_login] = "#{app_url}##{request.fullpath}".gsub! '.json', ''
          render json: {:redirect_to => new_user_session_path}
        }
      end
    end
  end


  def redirect_to_angular
    if request.format != "json"
      redirect_to "#{app_url}##{request.fullpath}"
    end
  end


  protected

  # It is important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as Devise::SessionsController
  #     as that could cause an infinite redirect loop.
  # - The request is an Ajax request as this can lead to very unexpected behaviour.
  # However, the request_format for our hold requests is json, which is not considered a navigational format.
  # So we must exclude the standard "is_navigational_format?" requirement.
  def storable_location?
    request.get? && !devise_controller? && !request.xhr?
  end


  def store_user_location!
    originating_location = request.fullpath
    if originating_location.present?
      # teacher set detail and create hold request have a '.json' in their urls, and we want a restful parent url
      originating_location = "#{app_url}##{originating_location}".gsub! '.json', ''
    end

    # :user is the scope we are authenticating
    store_location_for(:user, originating_location)
  end
end
