# frozen_string_literal: false

class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :redirect_if_old_domain
  before_action :adobe_titles

  protect_from_forgery only: [:update, :get, :put, :delete]

  def logged_in?
    user_signed_in?
  end

  def authenticate_admin_user!
    session[:redirect_after_login] = request.fullpath
    unless current_admin_user.present?
      # check for current_admin_user if not then redirect to login
      redirect_to "/admin/login"
    end
  end
  
  def append_info_to_payload(payload)
    super
    if ActiveRecord::Base.connected? && payload[:status].present?
      payload[:host] = request.host
      case payload[:status]
      when 200
        payload[:level] = "INFO"
      when payload[:status]  > 200 && payload[:status] < 400
        payload[:level] = "DEBUG"
      when payload[:status]  > 400
        payload[:level] = "WARNING"
      when payload[:status]  >= 500
        payload[:level] = "ERROR"
      end
      payload
    end
  end

  # Decides where to take the user who has just successfully logged in.
  def after_sign_in_path_for(resource)
    LogWrapper.log('DEBUG', {'message' => 'after_sign_in_path_for.start',
                             'method' => 'app/controllers/application_controller.rb.after_sign_in_path_for'})
    # be careful -- after first access stored_location_for clears to a nil, so read it once
    # and store it in a local var before printing out or any other access
    redirect_url = stored_location_for(:user)
    unless redirect_url.present?
      redirect_url = 'teacher_set_data'
    end

    # Redirect to admin dashboard if this is an admin login
    # Commenting this out due to inconsistency when demo-ing with account that are admins
    # (PB: Uncommenting this out because I can't find a login flow that it effects. I think observed issue may have been something else..)
    if !resource.nil? && resource.is_a?(AdminUser)
      redirect_url = if session[:redirect_after_login].present?
                       session[:redirect_after_login]
                     else
                       admin_dashboard_path
                     end
    end
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
      # flash[:error] = "Please sign in to complete your order!"
      respond_to do |format|
        format.html {
          # 2019-08-08: I think this is now ignored.  Commenting out for now, until make sure.
          # session[:redirect_after_login] = request.original_url
          # render json: {:redirect_to => new_user_session_path}
          redirect_to "/signin"
        }
        format.json {
          # 2019-08-08: I think this is now ignored.  Commenting out for now, until make sure.
          # session[:redirect_after_login] = "#{app_url}##{request.fullpath}".gsub! '.json', ''
          # render json: {:redirect_to => new_user_session_path}
          render json: {:redirect_to => "/signin"}
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

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  # If it is old domain redirect to new domain
  # eg: https://www.mylibrarynyc.org/about/participating-schools -> https://www.mylibrarynyc.org/schools
  # eg: https://sets.mylibrarynyc.org/help -> https://www.mylibrarynyc.org/faq
  # eg: https://www.mylibrarynyc.org/contacts-links -> https://www.mylibrarynyc.org/help
  # eg: https://www.mylibrarynyc.org/about/about-mylibrarynyc -> https://www.mylibrarynyc.org/faq
  def redirect_if_old_domain
    if request.host == ENV['MLN_SETS_SITE_HOSTNAME'] && request.fullpath == "/help"
      redirect_to "#{request.protocol}#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}/faq", :status => :moved_permanently
    elsif request.host == ENV['MLN_SETS_SITE_HOSTNAME'] && request.fullpath == "/"
      redirect_to "#{request.protocol}#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}/app#/teacher_sets", :status => :moved_permanently 
    elsif request.host == ENV['MLN_SETS_SITE_HOSTNAME']
      redirect_to "#{request.protocol}#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}#{request.fullpath}", :status => :moved_permanently 
    end

    if request.host == ENV['MLN_INFO_SITE_HOSTNAME'] && (request.fullpath == "/contacts-links")
      redirect_to "#{request.protocol}#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}/help", :status => :moved_permanently 
    elsif request.host == ENV['MLN_INFO_SITE_HOSTNAME'] && (request.fullpath == "/about/about-mylibrarynyc")
      redirect_to "#{request.protocol}#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}/faq", :status => :moved_permanently
    elsif request.host == ENV['MLN_INFO_SITE_HOSTNAME'] && (request.fullpath == "/about/participating-schools")
      redirect_to "#{request.protocol}#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}/schools", :status => :moved_permanently
    end
  end

  def store_user_location!
    originating_location = request.fullpath
    if originating_location.present?
      # teacher set detail and create hold request have a '.json' in their urls, and we want a restful parent url
      if params["controller"] == "teacher_sets" && params["action"] == "show" && params["id"].present?
        originating_location = "teacher_set_details/#{params['id']}"
      elsif originating_location == "/schools"
        originating_location = "participating-schools"
      elsif originating_location == "/faqs/show"
        originating_location = "faq"
      elsif originating_location == "/contacts"
        originating_location = "contacts"
      elsif params["controller"] == "books" && params["action"] == "show" && params["id"].present?
        originating_location = "book_details/#{params['id']}"
      elsif params["controller"] == "teacher_sets" && params["action"] == "index"
        query_params = request.query_parameters
        if params["grade_begin"] == "-1" && params["grade_end"] == "12" && params["grade_begin"] == "-1" && params["keyword"] == "" \
          && params["sort_order"] == ""
          query_params.delete("grade_begin")
          query_params.delete("grade_end")
          query_params.delete("keyword")
          query_params.delete("sort_order")
        end
        if query_params['language']
          query_params['language'] = query_params['language'].join
        end

        if query_params['area of study']
          query_params['area of study'] = query_params['area of study'].join
        end

        if query_params['set type']
          query_params['set type'] = query_params['set type'].join
        end

        if query_params['subjects']
          query_params['subjects'] = query_params['subjects'].join(",")
        end

        originating_location = "teacher_set_data?#{query_params.to_query}"
      elsif params["controller"] == "holds" && params["action"] == "ordered_holds_details" && params["cache_key"].present?
        originating_location = "ordered_holds/#{params['cache_key']}"
      else
        originating_location = "teacher_set_data"
      end
    end

    # :user is the scope we are authenticating
    store_location_for(:user, originating_location)
  end

  private 
              
  def set_csrf_cookie
    cookies["CSRF-TOKEN"] = {
         value: form_authenticity_token,
         domain: :all 
     }
  end
end