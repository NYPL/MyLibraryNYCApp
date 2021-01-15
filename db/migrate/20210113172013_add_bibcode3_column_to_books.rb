# frozen_string_literal: true

class AddBibcode3ColumnToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :bib_code_3, :string
  end
end
