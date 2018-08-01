class CreateSubjectsTeacherSetsTable < ActiveRecord::Migration
  def self.up
    create_table :subjects_teacher_sets, :id => false do |t|
      t.references :subject
      t.references :teacher_set
    end
    add_index :subjects_teacher_sets, [:subject_id, :teacher_set_id]
    add_index :subjects_teacher_sets, [:teacher_set_id]
  end

  def self.down
    drop_table :subjects_teacher_sets
  end
end
