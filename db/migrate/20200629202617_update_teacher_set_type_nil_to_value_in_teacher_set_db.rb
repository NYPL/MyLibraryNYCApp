# frozen_string_literal: true

class UpdateTeacherSetTypeNilToValueInTeacherSetDb < ActiveRecord::Migration[5.0]
  def change
    TeacherSet.new.update_set_type_from_nil_to_value
  end
end
