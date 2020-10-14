# frozen_string_literal: true

class NewsLetterController < ApplicationController
  include EncryptDecryptString

  def index
    flash[:error] = nil
    email = params['email']
    validate_news_letter_email_is_valid
    google_sheet = GoogleSpreadSheet.new.google_sheet_client
    emails_arr = google_sheet.rows.flatten
    email_already_in_google_sheets?(emails_arr, email)
    send_news_letter_confirmation_email(email)
    respond_to do |format|
      format.html 
      format.js 
    end
    flash[:notice] = "Thanks for subscribing! You will receive an e-mail confirmation shortly."
  rescue StandardError => e
    flash[:error] = e.message[0..75]
  end


  def validate_news_letter_email_is_valid
    is_valid = EmailValidator.valid? params['email']
    raise "Please enter a valid email address" unless is_valid
  end


  def send_news_letter_confirmation_email(email)
    encrypt_email = EncryptDecryptString.encrypt_string(email)
    AdminMailer.send_news_letter_confirmation_email(encrypt_email, email).deliver
  end


  # Checking here input email already in google sheets or not.
  def email_already_in_google_sheets?(emails_arr, email)
    is_valid_email = emails_arr.include?(email)
    if is_valid_email
      LogWrapper.log('DEBUG', {'message' => "Email already saved in google sheets. Email: #{email}",
                               'method' => 'email_already_in_google_sheets'})
      raise 'Email is already subscribed.'
    end
  end


  # Create news-letter email into google sheets
  def create_news_letter_email_in_google_sheets(params)
    begin
      google_sheet = GoogleSpreadSheet.new.google_sheet_client
      decrypt_email = EncryptDecryptString.decrypt_string(params["key"])
      google_sheet.insert_rows(google_sheet.num_rows + 1, [[decrypt_email]])
      is_saved_in_google_sheets = google_sheet.save
      LogWrapper.log('INFO', {'message' => "Saved in google sheets  #{is_saved_in_google_sheets}, params: #{params}",
                              'method' => 'create_news_letter_email_in_google_sheets'})
    rescue Exception => e
      LogWrapper.log('ERROR', {'message' => "Error occured while creating the newsletter email in google sheets, params: #{params},
                                error_message: #{e.message}", 'method' => 'create_news_letter_email_in_google_sheets'})
      is_saved_in_google_sheets = false
    end
  end
end
