# frozen_string_literal: true

class AddPrimarySubjectToTeacherSetsTable < ActiveRecord::Migration[3.2]
  def change
    add_column :teacher_sets, :primary_subject, :string
    add_index :teacher_sets, ["primary_subject"], :name => "index_primary_subject"
  end
end
