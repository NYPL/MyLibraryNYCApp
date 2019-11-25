# frozen_string_literal: true


class AddActiveToSchoolsTable < ActiveRecord::Migration
  def change
    add_column :schools, :active, :boolean, default: false
  end
end
