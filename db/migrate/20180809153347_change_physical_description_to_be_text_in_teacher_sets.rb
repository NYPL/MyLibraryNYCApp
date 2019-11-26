# frozen_string_literal: true

class ChangePhysicalDescriptionToBeTextInTeacherSets < ActiveRecord::Migration[4.2]
  def change
    change_column :teacher_sets, :physical_description, :text
  end
end
