# frozen_string_literal: true


class AddActiveToSchoolsTable < ActiveRecord::Migration[3.2]
  def change
    add_column :schools, :active, :boolean, default: false
  end
end
