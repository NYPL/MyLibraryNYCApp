# frozen_string_literal: true

class AddEmailNotificationsToAdminUsers < ActiveRecord::Migration[3.2]
  def change
    add_column :admin_users, :email_notifications, :boolean, :default => true
  end
end
