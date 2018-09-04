class Hold < ActiveRecord::Base

  attr_accessible :date_required

  validates_presence_of :teacher_set_id, :user_id

  belongs_to :teacher_set
  belongs_to :user
  has_many :hold_changes

  scope :pending, -> { where(status: 'pending') }
  scope :transit, -> { where(status: 'transit') }
  scope :trouble, -> { where(status: 'trouble') }
  scope :unavailable, -> { where(status: 'n_a') }
  scope :unseen, -> { where(status: 'new') }
  scope :new_or_pending, -> { where(status: ['new','pending']) }

  after_create :do_after_create

  STATUS_LABEL = {
    'new' => 'Order placed and awaiting review',
    'pending' => 'Order processed and awaiting next available set',
    'closed' => 'Order fulfilled; awaiting shipment',
    'cancelled' => 'You\'ve cancelled this order'
  }

  def status_label
    STATUS_LABEL[self.status]
  end

  def change_status(status, comment)
    if status != self.status
      hold_changes.new(:status => status, :comment => comment)
    end
  end

  def cancel!(reason)
    self.change_status('cancelled', reason)
  end

  def close!(by_whom)
    status = 'closed'
    puts "closing hold: #{self.inspect}"
  end

  def do_after_create
    generate_access_key
    send_confirmation_email
    recalculate_set_availability
    send_admin_notification_email
  end

  def name
    if !teacher_set.nil?
      "Hold for #{teacher_set.title}"
    end
  end

  # After hold is created, recalculate teacher_set availability string in case
  # this hold was placed on last avail copy
  #
  # We're only doing this when hold is created or status changes to pending
  # because a status change to closed means hold was filled, which the
  # ingest:update_availabilities cron should pick up in the normal course of
  # things after caches clear
  def recalculate_set_availability
    if ['new','pending','transit','trouble','unavailable'].include? status
      teacher_set.recalculate_availability
    end
  end

  # Generate unique 20 digit code, prefixed with id, to allow cancellation without signing in
  def generate_access_key
    self.access_key = [id.to_s, SecureRandom.hex(10)].join
    save!
  end

  # Should be placed in email communication for refernece
  def order_number
    "#{self.created_at.strftime('%Y%m%d')}.#{self.id}"
  end

  def send_admin_notification_email
    begin
      HoldMailer.admin_notification(self).deliver
    rescue => exception 
      raise exception
    end 
  end

  def send_confirmation_email
    HoldMailer.confirmation(self).deliver
  end


  def overdue?
    due_date_absolute < Time.now.strftime("%d %B %Y") && self.active == true
  end

  def due_date_absolute
    self.hold_end.strftime("%d %B %Y")
  end

  def overdue_rate
    1
  end

  def days_overdue
    # Calculate number of days over-due, multiply by overdue_rate
    overdue_rate * ((Time.now - self.hold_end) / 1.days)
  end

=begin
  def as_json(opts={})
    ret = {}
    [:id, :access_key, :date_required, :created, :status].each do |p|
      ret[p] = self[p]
    end
    ret
  end
=end
end
