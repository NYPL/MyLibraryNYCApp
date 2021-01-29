# frozen_string_literal: true

class SetUserAltEmailToNullAndAddUnique < ActiveRecord::Migration[5.0]
  def change
    execute "UPDATE users SET alt_email=NULL where alt_email=''"
    add_index :users, :alt_email, name: "index_users_alt_email", unique: true
  end
end
