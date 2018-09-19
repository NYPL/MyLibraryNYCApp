class ApplicationController < ActionController::Base
  protect_from_forgery

  def append_info_to_payload(payload)
    super
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
  
  
  def after_sign_in_path_for(resource)
    redirect_url = app_url
    # Redirect to admin dashboard if this is an admin login
    # Commenting this out due to inconsistency when demo-ing with account that are admins
    # (PB: Uncommenting this out because I can't find a login flow that it effects. I think observed issue may have been something else..)
    redirect_url = admin_dashboard_path if !resource.nil? && resource.is_a?(AdminUser)

    if session[:redirect_after_login]
      redirect_url = session[:redirect_after_login]
      session.delete(:redirect_after_login)
    end
    redirect_url
  end
  
  def require_login
    unless user_signed_in?
      flash[:error] = "Please sign in to complete your order!"
      respond_to do |format|
        format.html {
          session[:redirect_after_login] = request.original_url
          redirect_to new_user_session_path
        }
        format.json {
          session[:redirect_after_login] = "#{app_url}##{request.fullpath}".gsub! '.json', ''
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


end
