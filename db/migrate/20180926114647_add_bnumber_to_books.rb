# frozen_string_literal: true

class AddBnumberToBooks < ActiveRecord::Migration[4.2]
  def up
    add_column :books, :bnumber, :string, :limit => 20
  end
end
