class AddCampusRefToSchoolsTable < ActiveRecord::Migration
  def change
    add_column :schools, :campus_id, :int
    add_index :schools, [:campus_id]
  end
end
