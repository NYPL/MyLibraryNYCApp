# frozen_string_literal: true

class AddAvailableCountsToTeacherSetsTable < ActiveRecord::Migration[4.2]
  def change
    add_column :teacher_sets, :available_copies, :integer
    add_column :teacher_sets, :total_copies, :integer
  end
end
