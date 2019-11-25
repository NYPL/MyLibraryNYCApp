# frozen_string_literal: true

class AddActiveIndexToSchoolsTable < ActiveRecord::Migration
  def change
    add_index :schools, [:active]
  end
end
