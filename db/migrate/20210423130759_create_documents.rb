class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.string :event_type
      t.string :file_name
      t.string :file_path
      t.binary :file, :limit => 10.megabyte
      t.timestamps
    end
  end
end