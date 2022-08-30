# frozen_string_literal: true

class SettingsController < ApplicationController

  def signin
  end

  def signup
  end

  def signout
  end

  def index
    # unless logged_in?
    #   flash[:error] = "You must be logged in to access this page"

    #   # 2019-08-08: I think this is now ignored.  Commenting out for now, until make sure.
    #   # session[:redirect_after_login] = "/users/edit"
    #   store_location_for(:user, "/users/edit")

    #   render json: { accountdetails: {}, ordersNotPresentMsg: "", errorMsg: "You must be logged in to access this page" }
    #   return
    # end

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
      @alt_email = current_user.alt_email || current_user.email
      @contact_email = current_user.contact_email
      @school = current_user.school
      per_page = 15
      offset = 0
      offset = params[:page].present? ? params[:page].to_i - 1 : 0
      request_offset = per_page.to_i * offset.to_i

      @holds = current_user.holds.order("created_at DESC").limit(per_page).offset(request_offset)

      #If school is inactive for current user still need to show in school drop down.
      @schools << @school.name_id unless @school.active

      resp = {:id => current_user.id, current_user: current_user, :contact_email => @contact_email, :school => @school, :email => @email, :alt_email => @alt_email, :schools => @schools.to_h, :total_pages => (current_user.holds.length/per_page.to_f).ceil,
              :holds => @holds.map { |i| [created_at: i["created_at"].strftime("%b %-d, %Y"), quantity: i["quantity"], access_key: i["access_key"], title: i.teacher_set.title, status_label: i.status_label, status: i.status, teacher_set_id: i.teacher_set_id] if i.teacher_set.present? }.compact.flatten, :current_password => User.default_password.to_s}
    end
    ordersNotPresentMsg = @holds.length <= 0? "You have not yet placed any orders." : ""
    render json: { accountdetails: resp, ordersNotPresentMsg: ordersNotPresentMsg }
  end


  def acccount_details
    unless logged_in?
      redirect_to "/signin"
    end
  end


  def sign_up_details
    render json: { activeSchools: School.active_schools_data.to_h, 
                   emailMasks: AllowedUserEmailMasks.where(active:true).pluck(:email_pattern) }
  end

end
