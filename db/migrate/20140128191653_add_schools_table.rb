class AddSchoolsTable < ActiveRecord::Migration
  def up
    create_table "schools", :force => true do |t|
      t.string   "name"
    end
  end

  def down
    drop_table "schools"
  end
end
