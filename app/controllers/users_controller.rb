# frozen_string_literal: true

class UsersController < ApplicationController

  def settings
    if user_signed_in? && current_user
      redirect_to "/account_details"
    else
      # 2019-08-08: I think this is now ignored.  Commenting out for now, until make sure.
      # session[:redirect_after_login] = "/users/edit"
      store_location_for(:user, "/signin")

      render json: { accountdetails: {}, ordersNotPresentMsg: "",  errorMsg: "You must be logged in to access this page"}
    end
  end


  def check_email
    render :json => User.new.get_email_records(params[:email])
  end


  def create
    User.create(user_params)
  end

  private

  # Strong parameters: protect object creation and allow mass assignment.
  def user_params
    params.require(:email, :encrypted_password).permit(:email, :password, :password_confirmation, :remember_me,
                                                       :barcode, :alt_barcodes, :first_name, :last_name, :alt_email, :school_id, :pin)
  end
end
