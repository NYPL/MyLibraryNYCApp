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

end
