# frozen_string_literal: true

class ChangeUserBarcodeDatatype < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :barcode, 'bigint', null: false, unique: true
  end
end
