# frozen_string_literal: true

class ChangeSchoolCodeLimit < ActiveRecord::Migration[6.1]
  def up
    change_column :schools, :code, :string, :limit => 60
  end
end
