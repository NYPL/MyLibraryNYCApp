# frozen_string_literal: true

class NewsLetterController < ApplicationController
  def index
    validate_news_letter_email_is_valid
    GoogleSpreadSheet.new.create_news_letter_email_in_google_sheets(params)
    respond_to do |format|
      format.html 
      format.js 
    end
    flash[:notice] = "Thanks for subscribing! You will receive an e-mail confirmation shortly."
  rescue StandardError => e
    LogWrapper.log('ERROR', {'message' => "Error occcured while calling the google sheets. #{e.message}",
                             'method' => 'index'})
    flash[:error] = e.message
  end


  # Validate news-letter email is valid or not.
  # This below method allows these formats only. eg: test@dd.com, test@com.
  # For email validation using ruby gem, this is not custom regular expression validation.
  def validate_news_letter_email_is_valid
    is_valid = EmailValidator.valid? params['email']
    raise "Please enter a valid email address" unless is_valid
  end
end
