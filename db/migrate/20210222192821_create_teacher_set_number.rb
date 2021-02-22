# frozen_string_literal: true

class CreateTeacherSetNumber < ActiveRecord::Migration[5.0]
  def change
    add_column :teacher_sets, :number, :string
  end
end
