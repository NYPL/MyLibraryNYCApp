class AddContentsToTeacherSetsTable < ActiveRecord::Migration
  def change
    add_column :teacher_sets, :contents, :text
  end
end
