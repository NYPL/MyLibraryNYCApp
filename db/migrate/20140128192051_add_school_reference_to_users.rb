# frozen_string_literal: true

class AddSchoolReferenceToUsers < ActiveRecord::Migration[3.2]
  def change
    change_table :users do |t|
      t.references :school, index: true
    end
  end

  def down
    change_table :users do |t|
      t.remove :school_id
    end
  end
end
