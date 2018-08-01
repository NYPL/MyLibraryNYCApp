class CreateHolds < ActiveRecord::Migration
  def change
    create_table :holds do |t|
      t.integer :teacher_set_id, :limit => 8
      t.integer :user_id, :limit => 8
      t.date :date_required
      t.string :status, :limit => 9, :default => 'new'
      t.timestamps
    end
  end
end
