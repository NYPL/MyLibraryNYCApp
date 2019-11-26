# frozen_string_literal: true

class AddSchoolsTable < ActiveRecord::Migration[3.2]
  def up
    create_table "schools", :force => true do |t|
      t.string   "name"
    end
  end

  def down
    drop_table "schools"
  end
end
