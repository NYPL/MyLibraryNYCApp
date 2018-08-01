class AddPrimarySubjectToTeacherSetsTable < ActiveRecord::Migration
  def change
    add_column :teacher_sets, :primary_subject, :string
    add_index :teacher_sets, ["primary_subject"], :name => "index_primary_subject"
  end
end
