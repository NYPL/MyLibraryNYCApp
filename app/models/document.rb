class Document < ActiveRecord::Base

  validate :validate_event_type, :on => [:create, :update]
  validate :event_type_already_exist, :on => :create
  validate :validate_antivirus, :on => [:create, :update]

  # Event-types  
  EVENTS = [['-- Select --', 0], ['Calendar of events', 'calendar_of_event']]

  scope :calendar_of_event, -> { where(event_type: 'calendar_of_event') }

  
  def validate_antivirus
    return unless Ratonvirus.scanner.virus?(file_path)

    errors.add(:file, 'Your file is corrupted. Please upload virus free file')
  end


  def validate_event_type
    errors.add(:event_type, 'Please select event_type') if event_type.to_s == "0"
  end

  def event_type_already_exist
    return unless get_event_type.present?

    errors.add(:event_type, "#{event_type.titleize} type already created. Please use another type.")
  end

  def get_event_type
    Document.where(event_type: event_type)
  end

  def validate_file
    errors.add(:file, 'Please upload file') unless file.present?
  end

  def self.mln_calendar_from_google_doc
    event = calendar_of_event.first
    service = GoogleApiClient.drive_client
    file = service.export_file('13kuBBchhdhvIF7pFn-K5pdsGb_7M0MHeHTsYmrKaRP0', 'application/pdf')
    [event, file]
  end
end
