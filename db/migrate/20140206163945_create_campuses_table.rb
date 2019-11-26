# frozen_string_literal: true

class CreateCampusesTable < ActiveRecord::Migration[3.2]
  def up
    create_table "campuses", :force => true do |t|
      t.string  "name"
      t.integer :borough_id
      t.datetime "created_at",                  :null => false
      t.datetime "updated_at",                  :null => false
    end
    add_index :campuses, [:borough_id]
  end

  def down
    drop_table "campuses"
  end
end
