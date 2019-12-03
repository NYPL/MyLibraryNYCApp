# frozen_string_literal: true

class RenameBooksInSetsTable < ActiveRecord::Migration[4.2]
  def change
    rename_table :books_in_sets, :teacher_set_books

    rename_index :table_name, 'index_books_in_sets_book_id', 'index_teacher_set_books_book_id'
    rename_index :table_name, 'index_books_in_sets_teacher_set_id', 'index_teacher_set_books_teacher_set_id'
  end
end
