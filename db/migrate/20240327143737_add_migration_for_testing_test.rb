class AddMigrationForTestingTest < ActiveRecord::Migration[7.0]
  def change
    create_table :testtable do |t|
      t.string :name
      t.string :email      
      t.timestamps # This will add `created_at` and `updated_at` columns automatically
    end
  end
end
