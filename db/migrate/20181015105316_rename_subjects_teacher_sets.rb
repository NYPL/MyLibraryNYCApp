# frozen_string_literal: true

class RenameSubjectsTeacherSets < ActiveRecord::Migration[4.2]
  def change
    rename_table :subjects_teacher_sets, :subject_teacher_sets
  end
end
