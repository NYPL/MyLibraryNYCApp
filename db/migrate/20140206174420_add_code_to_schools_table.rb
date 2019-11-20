# frozen_string_literal: true

class AddCodeToSchoolsTable < ActiveRecord::Migration
  def change
    add_column :schools, :code, :string, :limit => 8
    add_index :schools, [:code], :unique => true
  end
end
