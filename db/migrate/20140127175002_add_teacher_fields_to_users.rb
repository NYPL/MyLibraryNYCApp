# frozen_string_literal: true

class AddTeacherFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :barcode, :integer, :limit => 8
    add_column :users, :first_name, :string, :limit => 40
    add_column :users, :last_name, :string, :limit => 40
    add_column :users, :alt_email, :string
    add_column :users, :home_library, :string, :limit => 6
  end
end
