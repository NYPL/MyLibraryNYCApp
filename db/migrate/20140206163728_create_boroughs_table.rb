# frozen_string_literal: true

class CreateBoroughsTable < ActiveRecord::Migration[3.2]
  def up
    create_table "boroughs", :force => true do |t|
      t.string   "name"
      t.datetime "created_at",                  :null => false
      t.datetime "updated_at",                  :null => false
    end
  end

  def down
    drop_table "boroughs"
  end
end
