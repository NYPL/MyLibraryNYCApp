# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    layout 'empty', :only => [:timeout_check]

    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
  


    # POST /resource/sign_in
    def create
      resource = User.find_by(email: params[:user][:email].downcase)
      if resource
        sign_in :user, resource
        render json: {
          logged_in: true,
          user: current_user,
          user_return_to: after_sign_in_path_for(resource) || 'teacher_set_data',
          sign_in_msg: "Signed in successfully"
        }
      else
        render json: { 
          logged_in: false
        }
      end
    end

    # DELETE /resource/sign_out
    def destroy
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      return unless signed_out

      render json: {
        status: 200,
        logged_out: true,
        root_path: root_path,
        sign_out_msg: "Signed out successfully"
      }
      
    end

    ## Checks if the user's session has been timed out.
    # If yes, then gives a visual notification to the user.
    def timeout_check
      # session["warden.user.user.session"] comes from adding timeoutable to the user model
      # example: {"last_request_at"=>1537283353}
      if !session || !session["warden.user.user.session"]
        render json: { timeout_status: 'no_current_user' }, status: 100
      elsif session["warden.user.user.session"] && Time.zone.now.to_i > timeout_timestamp.to_i
        sign_out current_user
        flash[:notice] = "Your session has timed out."
        render json: { timeout_status: 'timed_out' }, status: 200
      elsif session["warden.user.user.session"] && Time.zone.now.to_i > timeout_warning_timestamp.to_i
        render json: { timeout_status: 'timeout_warning' }, status: 200
      else
        render json: { timeout_status: 'not_timed_out' }, status: 200
      end
    end

    protected

    def auth_options
      { scope: resource_name, recall: "#{controller_path}#new" }
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
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
end
