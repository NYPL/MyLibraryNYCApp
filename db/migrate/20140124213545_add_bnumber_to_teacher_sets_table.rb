class AddBnumberToTeacherSetsTable < ActiveRecord::Migration
  def change
    add_column :teacher_sets, :bnumber, :string, :limit => 20
  end
end
