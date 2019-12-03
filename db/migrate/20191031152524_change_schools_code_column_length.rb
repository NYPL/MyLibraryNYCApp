# frozen_string_literal: true

class ChangeSchoolsCodeColumnLength < ActiveRecord::Migration[4.2]
  def change
    change_column :schools, :code, :string, :limit => 32
  end
end
