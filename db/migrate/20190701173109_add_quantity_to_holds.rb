# frozen_string_literal: true

class AddQuantityToHolds < ActiveRecord::Migration
  def change
    add_column :holds, :quantity, :integer, :default => 1
  end
end
