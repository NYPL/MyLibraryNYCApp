# frozen_string_literal: true

class AddPrimaryKeyToBooksInSets < ActiveRecord::Migration
  def change
    add_column :books_in_sets, :id, :primary_key
  end
end
