# frozen_string_literal: true

class AddActiveIndexToSchoolsTable < ActiveRecord::Migration[4.2]
  def change
    add_index :schools, [:active]
  end
end
