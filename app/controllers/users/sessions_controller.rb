# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  #before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    resource = User.find_by(email: params[:user][:email].downcase)
    sign_in :user, resource, bypass: true
    current_user.remember_me!
    if current_user
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
    if signed_out
      render json: {
        status: 200,
        logged_out: true,
        root_path: root_path,
        sign_out_msg: "Signed out successfully"
      }
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
end
