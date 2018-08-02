class AddAddressToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :street, :string
    add_column :schools, :state, :string
    add_column :schools, :postal_code, :string
  end
end
