class HoldMailer < ActionMailer::Base
  
  default :from => "orders@mylibrarynyc.org"
  
  def admin_notification(hold)
    @hold = hold
    @user = hold.user
    @teacher_set = hold.teacher_set
    emails = AdminUser.pluck(:email)
    mail(:to => emails, :subject => "New Order from #{@user.email} for #{@teacher_set.title}")
  end
  
  def confirmation(hold)
    @hold = hold
    @user = hold.user
    @teacher_set = hold.teacher_set
    mail(:to => @user.contact_email, :subject => "Your order confirmation for #{@teacher_set.title}")
  end
  
  def status_change(hold, status, message)
    @hold = hold
    @hold.status = status
    @user = hold.user
    @teacher_set = hold.teacher_set
    @message = message
    mail(:to => @user.contact_email, :subject => "Your teacher set order status for #{@teacher_set.title}")
  end

end