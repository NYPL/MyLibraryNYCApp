# frozen_string_literal: true

class AddIndexToSubjects < ActiveRecord::Migration
  def change
    add_index :subjects, ["title"], :name => "index_subjects_title", :unique => true
  end
end
