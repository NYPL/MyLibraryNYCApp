class ChangeSchoolsCodeColumnLength < ActiveRecord::Migration
  def change
    change_column :schools, :code, :string, :limit => 32
  end
end