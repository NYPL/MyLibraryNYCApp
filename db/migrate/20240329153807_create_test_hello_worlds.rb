class CreateTestHelloWorlds < ActiveRecord::Migration[7.0]
  def change
    create_table :test_hello_worlds do |t|
      t.string :name
      t.string :email
      t.timestamps
    end
  end
end
