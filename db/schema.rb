# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20180802145655) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

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
    t.string   "physical_description"
    t.text     "notes"
    t.text     "statement_of_responsibility"
    t.string   "cover_uri"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "books", ["title"], :name => "index_books_title"

  create_table "books_in_sets", :force => true do |t|
    t.integer "book_id",        :limit => 8,                :null => false
    t.integer "teacher_set_id", :limit => 8
    t.integer "rank",           :limit => 2, :default => 0, :null => false
  end

  add_index "books_in_sets", ["book_id"], :name => "index_books_in_sets_book_id"
  add_index "books_in_sets", ["teacher_set_id"], :name => "index_books_in_sets_teacher_set_id"

  create_table "boroughs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "campuses", :force => true do |t|
    t.string   "name"
    t.integer  "borough_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "campuses", ["borough_id"], :name => "index_campuses_on_borough_id"

  create_table "hold_changes", :force => true do |t|
    t.integer  "hold_id",       :limit => 8
    t.integer  "admin_user_id", :limit => 8
    t.string   "status",        :limit => 9
    t.text     "comment"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "holds", :force => true do |t|
    t.integer  "teacher_set_id", :limit => 8
    t.integer  "user_id",        :limit => 8
    t.date     "date_required"
    t.string   "status",         :limit => 9,  :default => "new"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "access_key",     :limit => 30
  end

  add_index "holds", ["access_key"], :name => "index_holds_access_key", :unique => true

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.integer  "campus_id"
    t.string   "code",           :limit => 8
    t.boolean  "active",                      :default => false
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "state"
    t.string   "postal_code"
    t.string   "phone_number"
    t.string   "borough"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schools", ["active"], :name => "index_schools_on_active"
  add_index "schools", ["campus_id"], :name => "index_schools_on_campus_id"
  add_index "schools", ["code"], :name => "index_schools_on_code", :unique => true

  create_table "subjects", :force => true do |t|
    t.string   "title",      :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "subjects", ["title"], :name => "index_subjects_title", :unique => true

  create_table "subjects_teacher_sets", :id => false, :force => true do |t|
    t.integer "subject_id"
    t.integer "teacher_set_id", :limit => 8
  end

  add_index "subjects_teacher_sets", ["subject_id", "teacher_set_id"], :name => "index_subjects_teacher_sets_on_subject_id_and_teacher_set_id"
  add_index "subjects_teacher_sets", ["teacher_set_id"], :name => "index_subjects_teacher_sets_on_teacher_set_id"

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
    t.text     "physical_description"
    t.string   "primary_language"
    t.string   "publisher"
    t.string   "series"
    t.integer  "grade_begin",                 :limit => 2
    t.integer  "grade_end",                   :limit => 2
    t.integer  "lexile_begin"
    t.integer  "lexile_end"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "available_copies"
    t.integer  "total_copies"
    t.string   "primary_subject"
    t.string   "bnumber",                     :limit => 20
    t.string   "set_type",                    :limit => 20
    t.text     "contents"
  end

  add_index "teacher_sets", ["availability"], :name => "index_teacher_sets_availaibilty"
  add_index "teacher_sets", ["grade_begin", "grade_end"], :name => "index_teacher_sets_grades"
  add_index "teacher_sets", ["lexile_begin", "lexile_end"], :name => "index_teacher_sets_lexile"
  add_index "teacher_sets", ["primary_subject"], :name => "index_primary_subject"
  add_index "teacher_sets", ["set_type"], :name => "index_teacher_set_type"
  add_index "teacher_sets", ["title"], :name => "index_teacher_sets_title"

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.integer  "barcode",                :limit => 8
    t.string   "first_name",             :limit => 40
    t.string   "last_name",              :limit => 40
    t.string   "alt_email"
    t.string   "home_library",           :limit => 6
    t.integer  "school_id"
    t.text     "alt_barcodes"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
