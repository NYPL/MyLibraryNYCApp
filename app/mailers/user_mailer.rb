class UserMailer < ActionMailer::Base

  default :from => "noreply@mylibrarynyc.org"

  def admin_notification(user)
    @user = user
    emails = AdminUser.pluck(:email)
    emails.delete('labs@nypl.org')
    #mail(:to => emails, :subject => "New User Registration - #{@user.email}")
  end

  def confirmation(user)
    @user = user
    mail(:to => @user.contact_email, :subject => "Welcome to MyLibraryNYC.")
  end

  def unsubscribe(user)
    @user = user
    mail(:to => @user.contact_email, :subject => "You have now unsubscribed from MyLibraryNyc.")
  end
end
