# frozen_string_literal: true

class ChangeStringToTextForTeacherSets < ActiveRecord::Migration
  def change
    change_column :teacher_sets, :description, :text
    change_column :books, :description, :text
  end
end
