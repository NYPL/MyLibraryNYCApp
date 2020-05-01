# frozen_string_literal: true

class HoldMailer < ActionMailer::Base
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
      LogWrapper.log('DEBUG', {
        'message' => "About to send hold order admin notification email on #{@teacher_set.title or 'unknown'} to #{@user.email or 'unknown'}",
        'method' => 'HoldMailer admin_notification'
      })
      mail(:to => emails, :subject => "New Order from #{@user.email or 'unknown'} for #{@teacher_set.title or 'unknown'}")
    rescue => exception
      LogWrapper.log('ERROR', {
        'message' => "Cannot send hold order admin notification email.  Backtrace=#{exception.backtrace}.",
        'method' => 'HoldMailer admin_notification'
      })
      raise exception
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
      LogWrapper.log('DEBUG', {
        'message' => "About to send patron hold order notification email to #{@user.email}",
        'method' => 'HoldMailer confirmation'
      })
      mail(:to => @user.contact_email, :subject => "Your order confirmation for #{@teacher_set.title}")
    rescue => exception
      LogWrapper.log('ERROR', {
        'message' => "Cannot send patron hold order notification email.  Backtrace=#{exception.backtrace}.",
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
      LogWrapper.log('DEBUG', {
        'message' => "status_change: About to send status_change notification email to #{@user.email}",
        'method' => 'HoldMailer status_change'
      })
      mail(:to => @user.contact_email, :subject => "Order #{@hold.status} | Your teacher set order for #{@teacher_set.title}")
    rescue => exception
      LogWrapper.log('ERROR', {
        'message' => "Cannot send patron status_change notification email.  Backtrace=#{exception.backtrace}.",
        'method' => 'HoldMailer status_change'
      })
    end
  end
end
