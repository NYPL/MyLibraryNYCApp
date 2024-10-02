# frozen_string_literal: true

class Hold < ActiveRecord::Base

  # add a quick filter scope to ActiveAdmin oldest unfulfilled hold orders first.
  scope :new_holds, -> { where(:status=>"new") }

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
    'new' => 'Awaiting Review',
    'pending' => 'Order processed and awaiting next available set',
    'closed' => 'Fulfilled',
    'cancelled' => 'Cancelled'
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
    puts "closing hold: #{self.inspect}"
    status = 'closed'
  end

  def do_after_create
    generate_access_key
    send_admin_notification_email
    send_confirmation_email
    recalculate_set_availability
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
  #
  # NOTE: This set availability calculation is provisional.  The source of truth
  # is Sierra.  When we run updates on teacher set data from Sierra to MyLibraryNYC,
  # those updates supercede any determinations made in this method.
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

  # Should be placed in email communication for reference.
  # TODO: Does this actually get used?  Look into
  def order_number
    "#{self.created_at.strftime('%Y%m%d')}.#{self.id}"
  end

  # Asks the hold_mailer to send a notificaion email to BookOps.
  def send_admin_notification_email
    return if Rails.env.development?

    HoldMailer.admin_notification(self).deliver
  end

  # Asks the hold_mailer to send a notification email to the teacher ordering the dataset.
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
