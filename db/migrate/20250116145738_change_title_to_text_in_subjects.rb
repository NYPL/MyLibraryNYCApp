class ChangeTitleToTextInSubjects < ActiveRecord::Migration[7.2]
  def change
    # Change the column from string to text
    change_column :subjects, :title, :text
  end
end
