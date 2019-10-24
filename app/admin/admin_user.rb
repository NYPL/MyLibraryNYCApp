ActiveAdmin.register AdminUser do
  menu :priority => 100

  member_action :enable_or_disable, :method => :put do
    admin_user = AdminUser.find(params[:id])
    admin_user.email_notifications = admin_user.email_notifications? ? false : true
    admin_user.save
    flash[:notice] = "E-mail notification change made!"
    redirect_to :action => :index
  end

  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    column "Email Notifications" do |admin_user|
      link_to  admin_user.email_notifications ? 'On' : 'Off' , url_for(:action => :enable_or_disable, :id => admin_user.id), :method => :put, :confirm => ('Are you sure want to update the e-mail setting?')
    end
    actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  #Setting up Strong Parameters
  #You must specify permitted_params within your admin_user ActiveAdmin resource which reflects a admin_user's expected params.
  controller do
    def permitted_params
      params.permit admin_user: [:email, :password, :password_confirmation, :email_notifications, :remember_me]
    end
  end
end

