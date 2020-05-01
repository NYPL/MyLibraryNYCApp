# frozen_string_literal: true

class AddIndexToBooks < ActiveRecord::Migration[4.2]
  def change
    remove_index :books, :name => "index_books_bnumber"
    add_index :books, ["bnumber"], :name => "index_books_bnumber"
  end
end
