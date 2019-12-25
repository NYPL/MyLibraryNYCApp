# frozen_string_literal: true

class AddAvailableCountsToTeacherSetsTable < ActiveRecord::Migration[4.2]
  # Note: Commented out 2019-12-25 to speed up travis builds.
  # def change
  #   add_column :teacher_sets, :available_copies, :integer
  #   add_column :teacher_sets, :total_copies, :integer
  # end
end
