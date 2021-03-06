# frozen_string_literal: true

class AddAddressToSchools < ActiveRecord::Migration[4.2]
  def change
    add_column :schools, :address_line_1, :string
    add_column :schools, :address_line_2, :string
    add_column :schools, :state, :string
    add_column :schools, :postal_code, :string
    add_column :schools, :phone_number, :string
    add_column :schools, :borough, :string
    add_column :schools, :created_at, :datetime
    add_column :schools, :updated_at, :datetime
  end
end
