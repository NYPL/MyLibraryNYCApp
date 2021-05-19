class Document < ActiveRecord::Base

  validate :validate_event_type, :on => [:create, :update]
  validate :event_type_already_exist, :on => :create

  EVENTS = [['-- Select --', 0], ['Calendar of events', 'calendar_of_event']]

  scope :calendar_of_event, -> { where(event_type: 'calendar_of_event') }

  validates :file_path, :presence => true, uniqueness: true


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


  def self.mln_calendar_from_google_doc
    calendar_event = calendar_of_event.first
    document_id = google_document_id(calendar_event)
    binding.pry
    mln_doc = GoogleApiClient.export_file(document_id, "application/pdf")
    [calendar_event, mln_doc]
  end

  def self.google_document_id(calendar_event)
    # URI.split(calendar_event.file_path)
    # ["https", nil, "docs.google.com", nil, nil, "/document/d/1IrIFrluIPv-lUxvT_mJJdbBGuQirbx4ISg1UXKhXp0o/edit", nil, nil, nil]
    calendar_event['file_path'].split('https://docs.google.com/document/d/')[1].gsub('/edit', '')
  end
end
