# frozen_string_literal: true

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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20240329153807) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "namespace"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.boolean  "email_notifications",                default: true
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "allowed_user_email_masks", force: :cascade do |t|
    t.string   "email_pattern",             null: false
    t.boolean  "active",                    default: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "books", id: :bigserial, force: :cascade do |t|
    t.text     "title"
    t.text     "sub_title"
    t.text     "format"
    t.text     "details_url"
    t.string   "publication_date"
    t.string   "isbn"
    t.string   "primary_language"
    t.text     "call_number"
    t.text     "description"
    t.text     "physical_description"
    t.text     "notes"
    t.text     "statement_of_responsibility"
    t.string   "cover_uri"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "bnumber",                     limit: 20
    t.string   "bib_code_3"
    t.index ["bnumber"], name: "index_books_bnumber", using: :btree
    t.index ["title"], name: "index_books_title", using: :btree
  end

  create_table "boroughs", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "campuses", force: :cascade do |t|
    t.string   "name"
    t.integer  "borough_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["borough_id"], name: "index_campuses_on_borough_id", using: :btree
  end

  create_table "faqs", force: :cascade do |t|
    t.text    "question"
    t.text    "answer"
    t.integer "position"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "hold_changes", force: :cascade do |t|
    t.bigint   "hold_id"
    t.bigint   "admin_user_id"
    t.string   "status",        limit: 9
    t.text     "comment"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "holds", force: :cascade do |t|
    t.bigint   "teacher_set_id"
    t.bigint   "user_id"
    t.date     "date_required"
    t.string   "status",         limit: 9,  default: "new"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "access_key",     limit: 30
    t.integer  "quantity",                  default: 1
    t.index ["access_key"], name: "index_holds_access_key", unique: true, using: :btree
  end

  create_table "schools", force: :cascade do |t|
    t.string   "name"
    t.integer  "campus_id"
    t.string   "code",           limit: 32
    t.boolean  "active",                     default: false
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "state"
    t.string   "postal_code"
    t.string   "phone_number"
    t.string   "borough"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at"
    t.index ["active"], name: "index_schools_on_active", using: :btree
    t.index ["campus_id"], name: "index_schools_on_campus_id", using: :btree
    t.index ["code"], name: "index_schools_on_code", unique: true, using: :btree
  end

  create_table "sierra_code_zcode_matches", force: :cascade do |t|
    t.integer  "sierra_code"
    t.string   "zcode"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "subject_teacher_sets", id: false, force: :cascade do |t|
    t.integer "subject_id"
    t.bigint  "teacher_set_id"
    t.index ["subject_id", "teacher_set_id"], name: "index_subject_teacher_sets_on_subject_id_and_teacher_set_id", using: :btree
    t.index ["teacher_set_id"], name: "index_subject_teacher_sets_on_teacher_set_id", using: :btree
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "title",      limit: 30
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["title"], name: "index_subjects_title", unique: true, using: :btree
  end

  create_table "teacher_set_books", force: :cascade do |t|
    t.bigint  "book_id",                              null: false
    t.bigint  "teacher_set_id"
    t.integer "rank",           limit: 2, default: 0, null: false
    t.index ["book_id"], name: "index_teacher_set_books_book_id", using: :btree
    t.index ["teacher_set_id"], name: "index_teacher_set_books_teacher_set_id", using: :btree
  end

  create_table "teacher_set_notes", force: :cascade do |t|
    t.bigint   "teacher_set_id"
    t.text     "content"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["teacher_set_id"], name: "index_book_set_notes_on_book_set_id", using: :btree
  end

  create_table "teacher_sets", id: :bigserial, force: :cascade do |t|
    t.text     "title"
    t.string   "call_number"
    t.text     "description"
    t.text     "details_url"
    t.text     "edition"
    t.datetime "publication_date"
    t.text     "statement_of_responsibility"
    t.text     "sub_title"
    t.string   "availability"
    t.string   "isbn"
    t.string   "language"
    t.text     "physical_description"
    t.string   "primary_language"
    t.text     "publisher"
    t.text     "series"
    t.integer  "grade_begin",                 limit: 2
    t.integer  "grade_end",                   limit: 2
    t.integer  "lexile_begin"
    t.integer  "lexile_end"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "available_copies"
    t.integer  "total_copies"
    t.string   "area_of_study"
    t.string   "bnumber",                     limit: 20
    t.text     "set_type"
    t.text     "contents"
    t.text     "last_book_change"
    t.string   "bib_code_3"
    t.index ["area_of_study"], name: "index_area_of_study", using: :btree
    t.index ["availability"], name: "index_teacher_sets_availaibilty", using: :btree
    t.index ["bnumber"], name: "index_teacher_sets_bnumber", unique: true, using: :btree
    t.index ["grade_begin", "grade_end"], name: "index_teacher_sets_grades", using: :btree
    t.index ["lexile_begin", "lexile_end"], name: "index_teacher_sets_lexile", using: :btree
    t.index ["set_type"], name: "index_teacher_set_type", using: :btree
    t.index ["title"], name: "index_teacher_sets_title", using: :btree
  end

  create_table "test_hello_worlds", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.bigint   "barcode", null: false
    t.string   "first_name",             limit: 40
    t.string   "last_name",              limit: 40
    t.string   "alt_email"
    t.string   "home_library",           limit: 6
    t.integer  "school_id"
    t.text     "alt_barcodes"
    t.string   "status"
    t.index "lower((email)::text), lower((alt_email)::text)", name: "index_users_on_email_or_alt_email_lower", using: :btree
    t.index ["barcode"], name: "index_users_barcode", unique: true, using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.bigint   "item_id",                    null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  create_table "documents", force: :cascade do |t|
    t.string "event_type"
    t.string "url"
    t.string "file_name"
    t.binary "file"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "testtable", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "users", "schools", column: "school_id", primary_key: "id"
end
