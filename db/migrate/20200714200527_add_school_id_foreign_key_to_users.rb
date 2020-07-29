# frozen_string_literal: true

class AddSchoolIdForeignKeyToUsers < ActiveRecord::Migration[5.0]
  def up
    add_foreign_key :users, :schools, column: :school_id, primary_key: "id"
  end

  def down
    remove_foreign_key_if_exists :users, column: :school_id
  end
end
