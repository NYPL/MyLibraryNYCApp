# frozen_string_literal: true

class NewsLetterController < ApplicationController

  def index
    email = params['email']
    validate_news_letter_email_is_valid
    google_sheet = GoogleSpreadSheet.new.google_sheet_client
    emails_arr = google_sheet.rows.flatten
    email_already_in_google_sheets?(emails_arr, email)
    binding.pry
    send_news_letter_confirmation_email(email)
    respond_to do |format|
      format.html 
      format.js 
    end
    flash[:notice] = "Thanks for subscribing! You will receive an e-mail confirmation shortly."
  rescue StandardError => e
    flash[:error] = e.message
  end


  def validate_news_letter_email_is_valid
    is_valid = EmailValidator.valid? params['email']
    raise "Please enter a valid email address" unless is_valid
  end


  def send_news_letter_confirmation_email(email)
    AdminMailer.send_news_letter_confirmation_email(email).deliver!
  end


  # Checking here input email already in google sheets or not.
  def email_already_in_google_sheets?(emails_arr, input_email)
    is_valid_email = emails_arr.include?(input_email)
    if is_valid_email
      LogWrapper.log('DEBUG', {'message' => "Email already saved in google sheets. Email: #{email}",
                               'method' => 'email_already_in_google_sheets'})
      raise 'Email is already subscribed.'
    end
  end
end
