# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_26_185223) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "resource_id", limit: 255, null: false
    t.string "resource_type", limit: 255, null: false
    t.integer "author_id"
    t.string "author_type", limit: 255
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "namespace", limit: 255
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "email_notifications", default: true
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "allowed_user_email_masks", id: :serial, force: :cascade do |t|
    t.string "email_pattern", limit: 255, null: false
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books", force: :cascade do |t|
    t.text "title"
    t.text "sub_title"
    t.text "format"
    t.text "details_url"
    t.string "publication_date", limit: 255
    t.string "isbn", limit: 255
    t.string "primary_language", limit: 255
    t.text "call_number"
    t.text "description"
    t.text "physical_description"
    t.text "notes"
    t.text "statement_of_responsibility"
    t.string "cover_uri", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bnumber", limit: 20
    t.string "bib_code_3"
    t.index ["bnumber"], name: "index_books_bnumber"
    t.index ["title"], name: "index_books_title"
  end

  create_table "boroughs", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "campuses", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "borough_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["borough_id"], name: "index_campuses_on_borough_id"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "faqs", id: :serial, force: :cascade do |t|
    t.text "question"
    t.text "answer"
    t.integer "position"
  end

  create_table "hold_changes", id: :serial, force: :cascade do |t|
    t.bigint "hold_id"
    t.bigint "admin_user_id"
    t.string "status", limit: 9
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "holds", id: :serial, force: :cascade do |t|
    t.bigint "teacher_set_id"
    t.bigint "user_id"
    t.date "date_required"
    t.string "status", limit: 9, default: "new"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_key", limit: 30
    t.integer "quantity", default: 1
    t.index ["access_key"], name: "index_holds_access_key", unique: true
  end

  create_table "schools", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "campus_id"
    t.string "code", limit: 32
    t.boolean "active", default: false
    t.string "address_line_1", limit: 255
    t.string "address_line_2", limit: 255
    t.string "state", limit: 255
    t.string "postal_code", limit: 255
    t.string "phone_number", limit: 255
    t.string "borough", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at"
    t.index ["active"], name: "index_schools_on_active"
    t.index ["campus_id"], name: "index_schools_on_campus_id"
    t.index ["code"], name: "index_schools_on_code", unique: true
  end

  create_table "sierra_code_zcode_matches", id: :serial, force: :cascade do |t|
    t.integer "sierra_code"
    t.string "zcode", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subject_teacher_sets", id: false, force: :cascade do |t|
    t.integer "subject_id"
    t.bigint "teacher_set_id"
    t.index ["subject_id", "teacher_set_id"], name: "index_subject_teacher_sets_on_subject_id_and_teacher_set_id"
    t.index ["teacher_set_id"], name: "index_subject_teacher_sets_on_teacher_set_id"
  end

  create_table "subjects", id: :serial, force: :cascade do |t|
    t.string "title", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_subjects_title", unique: true
  end

  create_table "teacher_set_books", id: :serial, force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "teacher_set_id"
    t.integer "rank", limit: 2, default: 0, null: false
    t.index ["book_id"], name: "index_teacher_set_books_book_id"
    t.index ["teacher_set_id"], name: "index_teacher_set_books_teacher_set_id"
  end

  create_table "teacher_set_notes", id: :serial, force: :cascade do |t|
    t.bigint "teacher_set_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_set_id"], name: "index_book_set_notes_on_book_set_id"
  end

  create_table "teacher_sets", force: :cascade do |t|
    t.text "title"
    t.string "call_number", limit: 255
    t.text "description"
    t.text "details_url"
    t.text "edition"
    t.datetime "publication_date"
    t.text "statement_of_responsibility"
    t.text "sub_title"
    t.string "availability", limit: 255
    t.string "isbn", limit: 255
    t.string "language", limit: 255
    t.text "physical_description"
    t.string "primary_language", limit: 255
    t.text "publisher"
    t.text "series"
    t.integer "grade_begin", limit: 2
    t.integer "grade_end", limit: 2
    t.integer "lexile_begin"
    t.integer "lexile_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "available_copies"
    t.integer "total_copies"
    t.string "area_of_study", limit: 255
    t.string "bnumber", limit: 20
    t.text "set_type"
    t.text "contents"
    t.text "last_book_change"
    t.index ["area_of_study"], name: "index_area_of_study"
    t.index ["availability"], name: "index_teacher_sets_availaibilty"
    t.index ["bnumber"], name: "index_teacher_sets_bnumber", unique: true
    t.index ["grade_begin", "grade_end"], name: "index_teacher_sets_grades"
    t.index ["lexile_begin", "lexile_end"], name: "index_teacher_sets_lexile"
    t.index ["set_type"], name: "index_teacher_set_type"
    t.index ["title"], name: "index_teacher_sets_title"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "barcode"
    t.string "first_name", limit: 40
    t.string "last_name", limit: 40
    t.string "alt_email", limit: 255
    t.string "home_library", limit: 6
    t.integer "school_id"
    t.text "alt_barcodes"
    t.string "status"
    t.index ["barcode"], name: "index_users_barcode", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", limit: 255, null: false
    t.bigint "item_id", null: false
    t.string "event", limit: 255, null: false
    t.string "whodunnit", limit: 255
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "users", "schools"
end
