# frozen_string_literal: true

class AddAltBarcodesToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :alt_barcodes, :text
  end
end
