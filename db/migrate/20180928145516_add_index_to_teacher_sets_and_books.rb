# frozen_string_literal: true

class AddIndexToTeacherSetsAndBooks < ActiveRecord::Migration
  def change
    add_index :teacher_sets, ["bnumber"], :name => "index_teacher_sets_bnumber", :unique => true
    add_index :books, ["bnumber"], :name => "index_books_bnumber", :unique => true
  end
end
