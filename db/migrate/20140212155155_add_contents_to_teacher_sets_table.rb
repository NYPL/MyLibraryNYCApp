# frozen_string_literal: true

class AddContentsToTeacherSetsTable < ActiveRecord::Migration
  def change
    add_column :teacher_sets, :contents, :text
  end
end
