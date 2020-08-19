# frozen_string_literal: true

class RenameTeacherSetSubjectToAreaOfStudy < ActiveRecord::Migration[4.2]

  def change
    rename_column :teacher_sets, :primary_subject, :area_of_study
    rename_index :teacher_sets, 'index_primary_subject', 'index_area_of_study'
  end
end
