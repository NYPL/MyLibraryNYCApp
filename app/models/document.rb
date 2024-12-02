# frozen_string_literal: true

class Document < ActiveRecord::Base

  validate :validate_event_type, :on => [:create, :update]
  validate :event_type_already_exist, :on => :create

  EVENTS = [['-- Select --', 0], ['Calendar of events', 'calendar_of_events']].freeze

  scope :calendar_of_events, -> { where(event_type: 'calendar_of_events').first }

  validates :url, :file_name, :presence => true, uniqueness: true

  validate :google_document, :on => [:create, :update]

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "event_type", "file", "file_name", "id", "id_value", "updated_at", "url"]
  end

  def validate_event_type
    errors.add(:event_type, 'Please select event_type') if event_type.to_s == "0"
  end

  def event_type_already_exist
    return unless Document.where(event_type: event_type).present?

    e_type = event_type.titleize
    error_msg = "#{e_type} type already created. Please use another type, or use the 'edit' link if you are trying to update #{e_type}"
    errors.add(:event_type, error_msg)
  end

  # Call GoogleApiClient to export google document.
  def google_document
    # Eg: url = https://docs.google.com/document/d/1iBzIYM_GG5OCXkuF4vKwSYRFaH3gd8Q_kuDrqT7Iu4U/edit
    # Split google document url than collect document-id.
    # document_id = 1iBzIYM_GG5OCXkuF4vKwSYRFaH3gd8Q_kuDrqT7Iu4U
    document_id = URI.split(url)[5].split('/')[3]
    GoogleApiClient.export_file(document_id, "application/pdf")
  rescue StandardError => e
    errors.add(:url, google_client_error_message(e))
  end

  def google_client_error_message(error)
    if error.status_code == 404
      email = JSON.parse(ENV.fetch('MLN_GOOGLE_ACCCOUNT', nil))['client_email']
      "There was an error accessing this file. Please check this URL is valid, and that the document is shared with #{email}"
    else
      error.message
    end
  end
end
