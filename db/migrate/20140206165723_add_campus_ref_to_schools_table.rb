# frozen_string_literal: true

class AddCampusRefToSchoolsTable < ActiveRecord::Migration[3.2]
  def change
    add_column :schools, :campus_id, :int
    add_index :schools, [:campus_id]
  end
end
