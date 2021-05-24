# frozen_string_literal: true

class Document < ActiveRecord::Base

  validate :validate_event_type, :on => [:create, :update]
  validate :event_type_already_exist, :on => :create

  EVENTS = [['-- Select --', 0], ['Calendar of events', 'calendar_of_event']].freeze

  scope :calendar_of_event, -> { where(event_type: 'calendar_of_event') }

  validates :url, :file_name, :presence => true, uniqueness: true

  validate :google_document, on: :create

  def validate_event_type
    errors.add(:event_type, 'Please select event_type') if event_type.to_s == "0"
  end


  def event_type_already_exist
    return unless Document.where(event_type: event_type).present?

    errors.add(:event_type, "#{event_type.titleize} type already created. Please use another type.")
  end


  # Call GoogleApiClient to export google document.
  def google_document
    # Collect google document-id from input url.
    document_id = URI.split(url)[5].split('/')[3]
    GoogleApiClient.export_file(document_id, "application/pdf")
  rescue StandardError => error
    errors.add(:url, google_client_error_message(error))
  end


  def google_client_error_message(error)
    if error.present? && error.status_code == 404
      "Please check the url and/or share document this #{JSON.parse(ENV['MLN_GOOGLE_ACCCOUNT'])['client_email']}"
    else
      error.message
    end
  end
end
