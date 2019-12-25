# frozen_string_literal: true

class AddIndexToSubjects < ActiveRecord::Migration[4.2]
  # Note: Commented out 2019-12-25 to speed up travis builds.
  # def change
  #   add_index :subjects, ["title"], :name => "index_subjects_title", :unique => true
  # end
end
