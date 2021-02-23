class RemoveTeacherSetNumber < ActiveRecord::Migration[5.0]
  def change
    remove_column :teacher_sets, :number
  end
end
