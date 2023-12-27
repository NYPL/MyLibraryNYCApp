# frozen_string_literal: true

class UserMailer < ActionMailer::Base
  include LogWrapper
  LOG_TAG = "UserMailer"

  default :from => '"MyLibraryNYC Admin" <no-reply@mylibrarynyc.org>'

  # Let the user know they've successfully unsubscribed from regular notification emails.
  # NOTE: Does not get used at this time.
  def unsubscribe(user)
    begin
      @user = user
      mail(:to => @user.contact_email, :subject => "You have now unsubscribed from MyLibraryNyc.")
    rescue => e
      # something went wrong.  perhaps the user isn't set properly, or maybe the email couldn't be sent out.
      Rails.logger.error("#{LOG_TAG}.unsubscribe: ")
      LogWrapper.log('ERROR', {
        'message' => "Cannot send unsubscribe confirmation email.  Backtrace=#{e.backtrace}.",
        'method' => 'UserMailer unsubscribe'
      })
      raise
    end
  end

  def account_confirmed_email_to_user(user)
    begin
      @user = user
      mail(:to => @user.contact_email, :subject => "Welcome to MyLibraryNYC.")
    rescue => e
      # something went wrong.  perhaps the user isn't set properly, or maybe the email couldn't be sent out.
      Rails.logger.error("#{LOG_TAG}.unsubscribe: ")
      LogWrapper.log('ERROR', {
        'message' => "Cannot send account confirmed email to user. Backtrace=#{e.backtrace}.",
        'method' => 'UserMailer account_confirmed_email_to_user'
      })
      raise
    end
  end
end
