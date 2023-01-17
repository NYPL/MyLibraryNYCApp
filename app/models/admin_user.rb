# frozen_string_literal: true

class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :email_notifications, :remember_me

  def name
    email
  end

  def self.is_valid_email(email)
    AdminUser.where(email: email)
  end
end
