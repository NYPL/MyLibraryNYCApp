# frozen_string_literal: true

class CreateSubjectsTable < ActiveRecord::Migration[3.2]
  def up
    create_table :subjects do |t|
      t.string   "title", :limit => 30
      t.timestamps
    end
  end

  def down
    drop_table :subjects
  end
end
