class AddEmailNotificationsToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :email_notifications, :boolean, :default => true
  end
end
