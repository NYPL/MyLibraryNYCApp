class AddBibcode3ColumnToTeachersetTable < ActiveRecord::Migration[5.0]
  def change
    add_column :teacher_sets, :bib_code_3, :string
  end
end
