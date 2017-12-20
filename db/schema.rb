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

ActiveRecord::Schema.define(version: 20171219093011) do

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
    t.string "mobile_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "full_response"
    t.text "questions"
    t.text "answers"
    t.text "question_answers"
    t.datetime "last_reminder_at"
    t.text "token"
    t.boolean "is_reviewed", default: false
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
    t.text "question_title"
    t.boolean "is_custom_field", default: false
    t.string "type_form_question_no"
    t.string "field_type"
    t.boolean "archive", default: false
  end

  create_table "job_applications", force: :cascade do |t|
    t.bigint "applicant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "merchant_id"
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
    t.string "email"
  end

  create_table "message_tags", force: :cascade do |t|
    t.string "tag_name"
    t.string "tag_value"
    t.bigint "job_application_question_id"
    t.boolean "is_editable", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_application_question_id"], name: "index_message_tags_on_job_application_question_id"
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

  create_table "screen_tabs", force: :cascade do |t|
    t.bigint "view_screen_id"
    t.string "name"
    t.integer "position"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["view_screen_id"], name: "index_screen_tabs_on_view_screen_id"
  end

  create_table "tab_fields", force: :cascade do |t|
    t.bigint "job_application_question_id"
    t.bigint "screen_tab_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["job_application_question_id"], name: "index_tab_fields_on_job_application_question_id"
    t.index ["screen_tab_id"], name: "index_tab_fields_on_screen_tab_id"
  end

  create_table "user_invitations", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.string "status", default: "pending"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: ""
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
    t.string "first_name"
    t.string "last_name"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "organization_name"
    t.text "address"
    t.decimal "lat"
    t.decimal "lng"
    t.boolean "tmp_password_status", default: false
    t.string "job_name"
    t.boolean "tmp_pasword_status", default: false
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "view_screens", force: :cascade do |t|
    t.string "screen_for"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active", default: true
  end

  add_foreign_key "job_applications", "applicants"
  add_foreign_key "tab_fields", "job_application_questions"
end
