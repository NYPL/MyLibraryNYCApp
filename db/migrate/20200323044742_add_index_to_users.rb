# frozen_string_literal: true

class AddIndexToUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :barcode, 'bigint'
    # add_index :users, :barcode, name: "index_users_barcode", unique: true
  end
end
