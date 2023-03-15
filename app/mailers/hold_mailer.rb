# frozen_string_literal: true

class HoldMailer < ApplicationMailer
  include LogWrapper
  LOG_TAG = "HoldMailer"
  default :from => '"MyLibraryNYC Orders" <orders@mylibrarynyc.org>'

  ##
  # Sends an email to BookOps, letting them know
  # a teacher set has been requested.
  def admin_notification(hold)
    begin
      @hold = hold
      @user = hold.user
      @teacher_set = hold.teacher_set
      emails = AdminUser.where(email_notifications:true).pluck(:email)
      mail(:to => emails, :subject => "New Order from #{@user.email or 'unknown'} for #{@teacher_set.title or 'unknown'}")
    rescue => e
      LogWrapper.log('ERROR', {
        'message' => "Cannot send hold order admin notification email.  Backtrace=#{e.backtrace}.",
        'method' => 'HoldMailer admin_notification'
      })
      raise e
    end
  end


  ##
  # Sends an email to the teacher, confirming that their request of
  # a teacher set has been received.
  def confirmation(hold)
    begin
      @hold = hold
      @user = hold.user
      @teacher_set = hold.teacher_set
      mail(:to => @user.contact_email, :subject => "Your order confirmation for #{@teacher_set.title}")
    rescue => e
      LogWrapper.log('ERROR', {
        'message' => "Cannot send patron hold order notification email.  Backtrace=#{e.backtrace}.",
        'method' => 'HoldMailer confirmation'
      })
      # NOTE:  Will not re-raise the exception, the teacher notification email isn't essential.
    end
  end


  def status_change(hold, status, details)
    begin
      @hold = hold
      @hold.status = status
      @user = hold.user
      @teacher_set = hold.teacher_set
      @details = details
      mail(:to => @user.contact_email, :subject => "Order #{@hold.status} | Your teacher set order for #{@teacher_set.title}")
    rescue => e
      LogWrapper.log('ERROR', {
        'message' => "Cannot send patron status_change notification email.  Backtrace=#{e.backtrace}.",
        'method' => 'HoldMailer status_change'
      })
    end
  end

  
  def teacher_set_deleted_notification(hold, status, details)
    begin
      @hold = hold
      @hold.status = status
      @user = hold.user
      @details = details
      mail(:to => @user.contact_email, :subject => "Order #{@hold.status} | The Teacher Set you requested has been deleted")
    rescue => e
      LogWrapper.log('ERROR', {
        'message' => "Cannot send teacher_set deleted notification email.  Backtrace=#{e.backtrace}.",
        'method' => 'HoldMailer teacher_set deleted notification'
      })
    end
  end
end
