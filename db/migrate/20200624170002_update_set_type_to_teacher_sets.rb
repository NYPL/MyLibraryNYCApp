# frozen_string_literal: true

class UpdateSetTypeToTeacherSets < ActiveRecord::Migration[5.0]
  def change
    TeacherSet.find_each do |ts|
      set_type = ts.get_set_type(ts.set_type)
      ts.set_type = set_type
      ts.save!
    end
  end
end
