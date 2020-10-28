# frozen_string_literal: true

class NewsLetterController < ApplicationController
  include EncryptDecryptString

  def index
    flash[:error] = nil
    email = params['email']
    # Checking input email is valid format or not.
    validate_news_letter_email_is_valid
    # Connect's to google sheets
    google_sheet = GoogleSpreadSheet.new.google_sheet_client
    emails_arr = google_sheet.rows.flatten
    # Checking here input email is already in google sheets or not.
    email_already_in_google_sheets?(emails_arr, email)
    # After input validations, send news-letter confirmation email to news-letter subscriber.
    send_news_letter_confirmation_email(email)
    respond_to do |format|
      format.html 
      format.js 
    end
    flash.now[:notice] = "Thanks for subscribing! You should receive an e-mail confirmation shortly."
  rescue StandardError => e
    LogWrapper.log('ERROR', {'message' => "Error occcured while calling the google sheets. #{e.message}",
                             'method' => 'index'})
    flash.now[:error] = e.message[0..75]
  end


  # Validate news-letter email is valid or not.
  # This below method allows these formats only. eg: test@dd.com, test@com.
  # For email validation using ruby gem, this is not custom regular expression validation.
  def validate_news_letter_email_is_valid
    is_valid = EmailValidator.valid? params['email']
    raise "Please enter a valid email address" unless is_valid
  end


  # sends news-letter confirmation email link to news-letter subscriber.
  # confirmation email should be an encryted format. Eg: "key=YHY7878999"
  def send_news_letter_confirmation_email(email)
    encrypt_email = EncryptDecryptString.encrypt_string(email)
    AdminMailer.send_news_letter_confirmation_email(encrypt_email, email).deliver
  end


  # Checking here input email already in google sheets or not.
  def email_already_in_google_sheets?(emails_arr, email)
    is_valid_email = emails_arr.include?(email)
    return unless is_valid_email

    LogWrapper.log('DEBUG', {'message' => "Email already saved in google sheets. Email: #{email}",
                             'method' => 'email_already_in_google_sheets'})
    raise 'That email is already subscribed to the MyLibraryNYC newsletter.' 
  end


  # Create news-letter email into google sheets
  # After clicking the confirmation email this method receive the input.
  # confirmation email link: eg: qa-www.mylibrarynyc.org/newsletter_confirmation?key=600BA5ABC25914E3B1
  # this method returns boolean value. Based on this value we are showing the success or failure message.
  def create_news_letter_email_in_google_sheets(params)
    google_sheet = GoogleSpreadSheet.new.google_sheet_client
    emails_arr = google_sheet.rows.flatten
    # Decryt the confirmation email string, than save to google sheets.
    decrypt_email = EncryptDecryptString.decrypt_string(params["key"])
    # Email is already in google sheets return true. Do not overwrite to google sheets.
    return true if emails_arr.include?(decrypt_email)
    
    google_sheet.insert_rows(google_sheet.num_rows + 1, [[decrypt_email]])
    is_saved_in_google_sheets = google_sheet.save
    LogWrapper.log('INFO', {'message' => "Saved in google sheets  #{is_saved_in_google_sheets}, params: #{params}",
                            'method' => 'create_news_letter_email_in_google_sheets'})
    is_saved_in_google_sheets
  rescue StandardError => e
    LogWrapper.log('ERROR', {'message' => "Error occured while creating the newsletter email in google sheets, params: #{params},
                              error_message: #{e.message}", 'method' => 'create_news_letter_email_in_google_sheets'})
    false
  end
end
