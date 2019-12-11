# frozen_string_literal: true

class AddCodeToSchoolsTable < ActiveRecord::Migration[4.2]
  def change
    add_column :schools, :code, :string, :limit => 8
    add_index :schools, [:code], :unique => true
  end
end
