class SettingsController < ApplicationController

  def index
    unless user_signed_in?
      flash[:error] = "You must be logged in to access this page"
      session[:redirect_after_login] = "/users/edit"
      redirect_to new_user_session_path
      return
    end

    unless params[:settings].nil?
      current_user.update_attributes({
        :alt_email => params[:settings][:contact_email],
        :school_id => params[:settings][:school][:id]
      })
    end

    resp = {}

    unless current_user.nil?
      @email = current_user.email
      @alt_email = current_user.alt_email
      @contact_email = current_user.contact_email
      @school = current_user.school
      @holds = current_user.holds.order("created_at DESC")

      resp = {:id => current_user.id, :contact_email => @contact_email, :school => @school, :email => @email, :alt_email => @alt_email}
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: resp }
    end
  end
end
