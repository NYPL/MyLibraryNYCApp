# frozen_string_literal: true

class AddTypeToTeacherSetsTable < ActiveRecord::Migration[4.2]
  def change
    add_column :teacher_sets, :set_type, :string, :limit => 20 # Subject Set / Single-Item Set
    add_index :teacher_sets, ["set_type"], :name => "index_teacher_set_type"
  end
end
