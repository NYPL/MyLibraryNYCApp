# frozen_string_literal: true

class AddAccessKeyToHoldsTable < ActiveRecord::Migration[4.2]
  def change
    add_column :holds, :access_key, :string, :limit => 30
    add_index :holds, ["access_key"], :name => "index_holds_access_key", :unique => true
  end
end
