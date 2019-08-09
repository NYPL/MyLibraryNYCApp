class UsersController < ApplicationController

  def settings
    if user_signed_in?
      redirect_to "/users/edit"
    else
      flash[:error] = "You must be logged in to access this page"
      session[:redirect_after_login] = "/users/edit"

      redirect_to new_user_session_path
    end
  end


  def check_email
    render :json => User.new.get_email_records(params[:email])
  end

end
