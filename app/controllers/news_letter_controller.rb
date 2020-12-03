# frozen_string_literal: true

class NewsLetterController < ApplicationController
  include EncryptDecryptString
  SPREAD_SHEET_ID = ENV['NEWS_LETTER_GOOGLE_SPREAD_SHEET_ID']
  SHEET_NAME = 'Sheet1'
  RANGE = "Sheet1!A1:B"

  def index
    flash[:error] = nil
    email = params['email']
    # Checking input email is valid format or not.
    validate_news_letter_email_is_valid
    # Connect's to google sheets and get's google sheet emails.
    emails_arr = news_letter_google_spread_sheet_emails

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

  
  # Connect's to google client and read all news-letter emails
  def news_letter_google_spread_sheet_emails
    service = GoogleApiClient.new.sheets_client
    response = service.get_spreadsheet_values(SPREAD_SHEET_ID, RANGE)
    response.values.present? ? response.values.flatten : []
  end


  # Connect's to google client and append news-letter email to google sheet.
  def write_news_letter_emails_to_google_sheets(email)
    service = GoogleApiClient.new.sheets_client
    value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: [[email]])
    service.append_spreadsheet_value(SPREAD_SHEET_ID, RANGE, value_range_object, value_input_option: 'RAW')
  end


  # Create news-letter email into google sheets
  # After clicking the confirmation email this method receive the input.
  # confirmation email link: eg: qa-www.mylibrarynyc.org/newsletter_confirmation?key=600BA5ABC25914E3B1
  # this method returns boolean value. Based on this value we are showing the success or failure message.
  def create_news_letter_email_in_google_sheets(params)
    emails_arr = news_letter_google_spread_sheet_emails

    # Decryt the confirmation email string, than save to google sheets.
    decrypt_email = EncryptDecryptString.decrypt_string(params["key"])
    # Email is already in google sheets return true. Do not overwrite to google sheets.
    return true if emails_arr.include?(decrypt_email)
    
    # Append news letter email to google sheeets
    response = write_news_letter_emails_to_google_sheets(decrypt_email)
    is_saved_in_google_sheets = true
    LogWrapper.log('INFO', {'message' => "Saved in google sheets  #{is_saved_in_google_sheets}, params: #{params}, 
                             tableRange: #{response.table_range}", 'method' => 'create_news_letter_email_in_google_sheets'})
    is_saved_in_google_sheets
  rescue StandardError => e
    LogWrapper.log('ERROR', {'message' => "Error occured while creating the newsletter email in google sheets, params: #{params},
                              error_message: #{e.message}", 'method' => 'create_news_letter_email_in_google_sheets'})
    false
  end
end
