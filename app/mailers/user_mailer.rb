class UserMailer < ActionMailer::Base
  LOG_TAG = "UserMailer"

  default :from => "noreply@mylibrarynyc.org"

  ##
  # Let the user know they've successfully unsubscribed from regular notification emails.
  # NOTE: Does not get used at this time.
  def unsubscribe(user)
    begin
      @user = user
      Rails.logger.debug("#{LOG_TAG}.unsubscribe: About to send unsubscribe confirmation email to #{@user.email or 'unknown'}")
      mail(:to => @user.contact_email, :subject => "You have now unsubscribed from MyLibraryNyc.")
    rescue => exception
      # something went wrong.  perhaps the user isn't set properly, or maybe the email couldn't be sent out.
      Rails.logger.error("#{LOG_TAG}.unsubscribe: Cannot send notification email.  Backtrace=#{exception.backtrace}.")
      raise
    end
  end
end
