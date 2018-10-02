class AddIndexToBooks < ActiveRecord::Migration
  def change
    remove_index :books, :name => "index_books_bnumber"
    add_index :books, ["bnumber"], :name => "index_books_bnumber"
  end
end
