# frozen_string_literal: true

class AddAltBarcodesToUsersTable < ActiveRecord::Migration[3.2]
  def change
    add_column :users, :alt_barcodes, :text
  end
end
