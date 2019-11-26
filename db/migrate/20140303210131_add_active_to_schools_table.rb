# frozen_string_literal: true


class AddActiveToSchoolsTable < ActiveRecord::Migration[4.2]
  def change
    add_column :schools, :active, :boolean, default: false
  end
end
