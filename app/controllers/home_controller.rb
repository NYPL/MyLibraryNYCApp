# frozen_string_literal: true

class HomeController < ApplicationController
  #layout 'empty', :only => [ :extend_session_iframe ]

  def index
  end


  def get_mln_file_name
    calendar_event = Document.calendar_of_events
    mln_calendar_file_name = calendar_event.present? ? "#{calendar_event.file_name}.pdf" : "error"
    render json: { mln_calendar_file_name: mln_calendar_file_name }
  end

  def swagger_docs
  	render :json => File.read("app/controllers/api/swagger/swaggerDoc.json")
  end 

  
  def secondary_menu
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


  def help; 
    if storable_location?
      store_user_location!
    end
  end


  def faq
    faqs = FaqsController.new.frequently_asked_questions
    render json: { faqs: faqs }
  end

  def faq_data
    
  end

  # Create news-letter confirmation email in google sheets
  def newsletter_confirmation
    @is_success = NewsLetterController.new.create_news_letter_email_in_google_sheets(params)
  end

  def calendar_event_error
  end

  def calendar_event
    render json: { calendar_event: Document.calendar_of_events }
  end

  # Read MylibraryNyc calendar pdf from document table and display's in home page.
  def mln_calendar
    @calendar_event = Document.calendar_of_events
    return @calendar_event if @calendar_event.nil? && params["filename"] == "error"
    file = @calendar_event.present? && @calendar_event.file.present? ? @calendar_event.file : nil
    if params["filename"] != "error"
      respond_to do |format|
        format.pdf { send_data(file, type: "application/pdf", disposition: :inline) }
      end
    elsif @calendar_event.present? && params["filename"] == "error"
      redirect_to root_url
    end
  end
end
