class AddAddressToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :address_line_1, :string
    add_column :schools, :address_line_2, :string
    add_column :schools, :state, :string
    add_column :schools, :postal_code, :string
    add_column :schools, :phone_number, :string
    add_column :schools, :borough, :string
  end
end
