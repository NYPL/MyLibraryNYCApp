# frozen_string_literal: true

class AlterSubjectsTeacherSetsFk < ActiveRecord::Migration[4.2]
  def up
    change_column :subjects_teacher_sets, :teacher_set_id, 'bigint'
  end

  def down
    change_column :subjects_teacher_sets, :teacher_set_id, 'int'
  end
end
