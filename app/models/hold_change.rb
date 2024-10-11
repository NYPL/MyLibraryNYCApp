# frozen_string_literal: true

class HoldChange < ActiveRecord::Base

  # attr_accessible :status, :comment, :hold_id, :admin_user_id

  validates_presence_of :hold_id, :status
  belongs_to :hold
  belongs_to :admin_user, optional: true

  after_save :do_after_save

  def do_after_save
    update_hold

    # This is a code change. Need to check on the expected behavior here! @JC 2024-10-07
    if hold.teacher_set.present? && hold.teacher_set.availability != 'unavailable'
      send_change_status_email
    else
      send_teacher_set_deleted_email
    end
  end

  def self.ransackable_associations(auth_object = nil)
    ['admin_user', 'hold']
  end

  def self.ransackable_attributes(auth_object = nil)
    ["admin_user_id", "comment", "created_at", "hold_id", "id", "id_value", "status", "updated_at"]
  end

  private

  def send_change_status_email
    # deliver email if status has been changed to error, pending, closed, or cancelled
    HoldMailer.status_change(hold, status, comment).deliver if ['error', 'pending', 'closed', 'cancelled'].include? status
  end

  def send_teacher_set_deleted_email
    HoldMailer.teacher_set_deleted_notification(hold, status, comment).deliver if ['closed', 'cancelled'].include? status
  end

  def update_hold
    # puts "updating hold status: ", hold.status, status
    hold.status = status
    hold.save
  end

end
