# frozen_string_literal: true

require 'open-uri'

class HomeController < ApplicationController
  layout 'empty', :only => [ :extend_session_iframe ]

  def index; end

  def mln_file_names
    calendar_event = Document.calendar_of_events
    mln_calendar_file_name = calendar_event.present? ? "#{calendar_event.file_name}.pdf" : "error"
    render json: { mln_calendar_file_name: mln_calendar_file_name, menu_of_services_file_name: "menu_of_services.pdf" }
  end

  def swagger_docs
    render :json => File.read("app/controllers/api/swagger/swaggerDoc.json")
  end

  # I'm not sure this is still needed (@JC 2024-10-03)
  def secondary_menu; end

  # for timing out sessions, this method reloads a hidden iframe so that the user's session["warden.user.user.session"]["last_request_at"] updates
  def extend_session_iframe
    user_signed_in?
  end

  def digital_resources; end

  def help
    store_location_for(:user, "contact")
  end

  def faq_data; end

  # Create news-letter confirmation email in google sheets
  def newsletter_confirmation; end

  def newsletter_confirmation_msg
    is_success = NewsLetterController.new.create_news_letter_email_in_google_sheets(params)
    render json: { success: is_success }
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

  def menu_of_services
    if params["filename"] == "menu_of_services"
      respond_to do |format|
        file = URI.open(File.join(Rails.root, 'app/javascript/pdf/2021_2022_MyLibraryNYC_Menu_of_Services_for_Educators.pdf'))
        menu_of_services_pdf = file.read
        format.pdf do
          send_data(menu_of_services_pdf, type: "application/pdf", disposition: :inline)
        end
      end
    else
      redirect_to root_url
    end
  end
end
