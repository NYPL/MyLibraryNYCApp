# frozen_string_literal: true

class RenameSubjectsTeacherSets < ActiveRecord::Migration
  def change
    rename_table :subjects_teacher_sets, :subject_teacher_sets

    # rename_index :subjects_teacher_sets, :index_subjects_teacher_sets_on_subject_id_and_teacher_set_id, :index_subject_teacher_sets_on_subject_id_and_teacher_set_id
    # rename_index :subjects_teacher_sets, :index_subjects_teacher_sets_on_teacher_set_id, :index_subject_teacher_sets_on_teacher_set_id
  end
end
