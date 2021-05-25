class AddDocumentFile < ActiveRecord::Migration[6.1]
  def up
    add_column :documents, :url, :string
    remove_column :documents, :file_path
  end
end
