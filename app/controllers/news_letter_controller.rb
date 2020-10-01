# frozen_string_literal: true

class NewsLetterController < ApplicationController
  def index
    GoogleSpreadSheet.new.create_news_letter_email_in_google_sheets(params)
    respond_to do |format|
      format.html 
      format.js 
    end
  end
end
