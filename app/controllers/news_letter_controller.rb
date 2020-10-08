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
    flash[:error] = e.message
  end


  def validate_news_letter_email_is_valid
    is_valid = EmailValidator.valid? params['email']
    raise "Please enter a valid email address" unless is_valid
  end
end
