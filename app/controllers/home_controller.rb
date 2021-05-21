# frozen_string_literal: true

class HomeController < ApplicationController
  layout 'empty', :only => [ :extend_session_iframe ]

  def index
    @mln_calendar_file_name = calendar_event.present? ? calendar_event.file_name : "error"
  end


  def swagger_docs
  	render :json => File.read("app/controllers/api/swagger/swaggerDoc.json")
  end 

  
  # for timing out sessions, this method reloads a hidden iframe so that the user's session["warden.user.user.session"]["last_request_at"] updates
  def extend_session_iframe
    user_signed_in?
  end


  # Display's mylibrarynyc information
  def about; end


  # Display's mylibrarynyc contact's information
  def contacts; end


  # Display's mylibrarynyc school's information
  def participating_schools; end
  

  def digital_resources; end


  def help; end


  def faq
    @faqs = FaqsController.new.frequently_asked_questions
  end


  # Create news-letter confirmation email in google sheets
  def newsletter_confirmation
    @is_success = NewsLetterController.new.create_news_letter_email_in_google_sheets(params)
  end

  def calendar_event
    event = Document.calendar_of_event.first
    return unless event.present?
    event
  end

  def mln_calendar
    if calendar_event.present? && calendar_event.file.present?
      respond_to do |format|
        format.pdf { send_data(calendar_event.file, type: "application/pdf", disposition: :inline) }
      end
    else
      render :json => "Mylibrarynyc calendar not found. Please upload calendar event."
    end
  end

end
