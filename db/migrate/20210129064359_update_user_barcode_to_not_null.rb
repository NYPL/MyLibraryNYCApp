# frozen_string_literal: true

class UpdateUserBarcodeToNotNull < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :barcode, 'bigint', null: false
  end
end
