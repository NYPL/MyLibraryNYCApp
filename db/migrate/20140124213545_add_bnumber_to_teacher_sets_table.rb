# frozen_string_literal: true

class AddBnumberToTeacherSetsTable < ActiveRecord::Migration[4.2]
  def change
    add_column :teacher_sets, :bnumber, :string, :limit => 20
  end
end
