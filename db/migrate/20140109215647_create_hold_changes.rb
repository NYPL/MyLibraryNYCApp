# frozen_string_literal: true

class CreateHoldChanges < ActiveRecord::Migration[4.2]
  def change
    create_table :hold_changes do |t|
      t.integer :hold_id, :limit => 8
      t.integer :admin_user_id, :limit => 8
      t.string :status, :limit => 9
      t.text :comment
      t.timestamps
    end
  end
end
