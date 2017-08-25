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

ActiveRecord::Schema.define(version: 20170824004052) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "applicants", force: :cascade do |t|
    t.bigint "merchant_id"
    t.string "mobile_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_applicants_on_merchant_id"
  end

  create_table "default_settings", force: :cascade do |t|
    t.integer "default_max_application_limit_for_trail_merchant"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_application_questions", force: :cascade do |t|
    t.string "question"
    t.integer "field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_applications", force: :cascade do |t|
    t.bigint "applicant_id"
    t.text "token"
    t.text "full_response"
    t.text "questions"
    t.text "answers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_reviewed", default: false
    t.text "question_answers"
    t.datetime "last_reminder_at"
    t.index ["applicant_id"], name: "index_job_applications_on_applicant_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "uuid"
    t.text "token"
    t.string "mobile_no"
    t.boolean "is_created", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.datetime "last_reminder_at"
  end

  create_table "reminder_message_translations", force: :cascade do |t|
    t.integer "reminder_message_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "message"
    t.index ["locale"], name: "index_reminder_message_translations_on_locale"
    t.index ["reminder_message_id"], name: "index_reminder_message_translations_on_reminder_message_id"
  end

  create_table "reminder_messages", force: :cascade do |t|
    t.string "reminder_for"
    t.integer "remind_after"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remind_preference"
  end

  create_table "response_message_translations", force: :cascade do |t|
    t.integer "response_message_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "message"
    t.index ["locale"], name: "index_response_message_translations_on_locale"
    t.index ["response_message_id"], name: "index_response_message_translations_on_response_message_id"
  end

  create_table "response_messages", force: :cascade do |t|
    t.string "message_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "mobile_no"
    t.string "locale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active", default: true
    t.boolean "is_trail_account", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "applicants", "merchants"
  add_foreign_key "job_applications", "applicants"
end
