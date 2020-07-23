# frozen_string_literal: true

class InitialSchema < ActiveRecord::Migration[4.2]
  def up
    create_table "books", :force => true do |t|
      t.string   "title"
      t.string   "sub_title"
      t.string   "format"
      t.string   "details_url"
      t.string   "publication_date"
      t.string   "isbn"
      t.string   "primary_language"
      t.string   "call_number"
      t.text     "description"
      t.text     "physical_description"
      t.text     "notes"
      t.text     "statement_of_responsibility"
      t.string   "cover_uri"
      t.datetime "created_at",                  :null => false
      t.datetime "updated_at",                  :null => false
    end
    change_column :books, :id, 'bigint'
    add_index :books, ["title"], :name => "index_books_title", :unique => false

    create_table "books_in_sets", :id => false, :force => true do |t|
      t.integer "book_id",        :limit => 8, :null => false
      t.integer "teacher_set_id", :limit => 8
      t.integer "rank",           :limit => 2, :default => 0, :null => false
    end
    add_index :books_in_sets, ["book_id"], :name => "index_books_in_sets_book_id", :unique => false
    add_index :books_in_sets, ["teacher_set_id"], :name => "index_books_in_sets_teacher_set_id", :unique => false

    create_table "teacher_set_notes", :force => true do |t|
      t.integer  "teacher_set_id", :limit => 8
      t.text     "content"
      t.datetime "created_at",                  :null => false
      t.datetime "updated_at",                  :null => false
    end

    add_index "teacher_set_notes", ["teacher_set_id"], :name => "index_book_set_notes_on_book_set_id"

    create_table "teacher_sets", :force => true do |t|
      t.string   "title"
      t.string   "call_number"
      t.text     "description"
      t.string   "details_url"
      t.string   "edition"
      t.datetime "publication_date"
      t.string   "statement_of_responsibility"
      t.string   "sub_title"
      t.string   "availability"
      t.string   "isbn"
      t.string   "language"
      t.string   "physical_description"
      t.string   "primary_language"
      t.string   "publisher"
      t.string   "series"
      t.integer  "grade_begin",                 :limit => 2
      t.integer  "grade_end",                   :limit => 2
      t.integer  "lexile_begin"
      t.integer  "lexile_end"
      t.datetime "created_at",                               :null => false
      t.datetime "updated_at",                               :null => false
    end
    change_column :teacher_sets, :id, 'bigint'
    add_index :teacher_sets, ["availability"], :name => "index_teacher_sets_availaibilty", :unique => false
    add_index :teacher_sets, ["grade_begin","grade_end"], :name => "index_teacher_sets_grades", :unique => false
    add_index :teacher_sets, ["lexile_begin","lexile_end"], :name => "index_teacher_sets_lexile", :unique => false
    add_index :teacher_sets, ["title"], :name => "index_teacher_sets_title", :unique => false

    create_table "users", :force => true do |t|
      t.string   "email", :default => "", :null => false
      t.string   "encrypted_password", :default => "", :null => false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count", :default => 0, :null => false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string   "unconfirmed_email"
      t.datetime "created_at",                             :null => false
      t.datetime "updated_at",                             :null => false
    end

    add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
    add_index "users", ["email"], :name => "index_users_on_email", :unique => true
    add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  end

  def down
  end
end
