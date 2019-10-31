class ChangeSchoolsCodeColumnLength < ActiveRecord::Migration[5.0]
  def change
    change_column :schools, :code, :string, :limit => 32
  end
end
