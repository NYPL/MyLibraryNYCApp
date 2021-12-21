# frozen_string_literal: true

class SettingsController < ApplicationController

  def index
    unless user_signed_in?
      flash[:error] = "You must be logged in to access this page"

      # 2019-08-08: I think this is now ignored.  Commenting out for now, until make sure.
      # session[:redirect_after_login] = "/users/edit"
      store_location_for(:user, "/users/edit")

      redirect_to new_user_session_path
      return
    end

    unless params[:settings].nil?
      current_user.update({
        :alt_email => params[:settings][:contact_email],
        :school_id => params[:settings][:school][:id]
      })
    end

    resp = {}
    #Active schools from school table.
    @schools = School.active_schools_data

    if current_user.present?
      @email = current_user.email
      @alt_email = current_user.alt_email
      @contact_email = current_user.contact_email
      @school = current_user.school
      @holds = current_user.holds.order("created_at DESC")

      #If school is inactive for current user still need to show in school drop down.
      @schools << @school.name_id unless @school.active
      resp = {:id => current_user.id, current_user: current_user, :contact_email => @contact_email, :school => @school, :email => @email, :alt_email => @alt_email, :schools => @schools.to_h,
              :holds => @holds.as_json }
    end
    render json: { accountdetails: resp }
  end


  def acccount_details
  end

end
