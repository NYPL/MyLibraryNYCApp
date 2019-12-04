# frozen_string_literal: true

class CreateSierraCodeZcodeMatches < ActiveRecord::Migration[4.2]
  def change
    create_table "sierra_code_zcode_matches", :force => true do |t|
      t.integer "sierra_code"
      t.string "zcode"
      t.datetime "created_at",                  :null => false
      t.datetime "updated_at",                  :null => false
    end
  end
end
