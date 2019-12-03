# frozen_string_literal: true

class AddContentsToTeacherSetsTable < ActiveRecord::Migration[4.2]
  def change
    add_column :teacher_sets, :contents, :text
  end
end
