class UserMailer < ActionMailer::Base

  default :from => "noreply@mylibrarynyc.org"

  def unsubscribe(user)
    @user = user
    mail(:to => @user.contact_email, :subject => "You have now unsubscribed from MyLibraryNyc.")
  end
end
