class HoldMailer < ActionMailer::Base
  LOG_TAG = "HoldMailer"
  default :from => "orders@mylibrarynyc.org"

  ##
  # Sends an email to BookOps, letting them know
  # a teacher set has been requested.
  def admin_notification(hold)
    begin
      @hold = hold
      @user = hold.user
      @teacher_set = hold.teacher_set

      emails = AdminUser.pluck(:email)
      Rails.logger.debug("#{LOG_TAG}.admin_notification: About to send hold order notification email on #{@teacher_set.title or 'unknown'} to #{@user.email or 'unknown'}")
      mail(:to => emails, :subject => "New Order from #{@user.email or 'unknown'} for #{@teacher_set.title or 'unknown'}")
    rescue => exception
      # something went wrong.  perhaps either user or teacher set aren't filled properly.
      # or maybe the email couldn't be sent out.
      Rails.logger.error("#{LOG_TAG}.admin_notification: Cannot send hold order notification email.  Backtrace=#{exception.backtrace}.")
      raise
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
      Rails.logger.debug("#{LOG_TAG}.confirmation: About to send hold order notification email to #{@user.email}")
      mail(:to => @user.contact_email, :subject => "Your order confirmation for #{@teacher_set.title}")
    rescue => exception
      # something went wrong.  perhaps either user or teacher set aren't filled properly.
      # or maybe the email couldn't be sent out.
      Rails.logger.error("#{LOG_TAG}.confirmation: Cannot send hold order notification email.  Backtrace=#{exception.backtrace}.")
      # NOTE:  Will not re-raise the exception, the teacher notification email isn't essential.
    end
  end


  def status_change(hold, status, details)
    @hold = hold
    @hold.status = status
    @user = hold.user
    @teacher_set = hold.teacher_set
    @details = details
    Rails.logger.debug("status_change: About to send hold order notification email to #{@user.email}")
    mail(:to => @user.contact_email, :subject => "Order #{@hold.status} | Your teacher set order for #{@teacher_set.title}")
  end

end
