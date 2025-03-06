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

ActiveRecord::Schema[7.1].define(version: 2025_03_06_050949) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.string "title"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "duration"
    t.json "instructions", default: []
    t.json "materials", default: []
  end

  create_table "activities_events", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "assigned_users", default: []
    t.string "custom_title"
    t.text "custom_description"
    t.index ["activity_id"], name: "index_activities_events_on_activity_id"
    t.index ["event_id"], name: "index_activities_events_on_event_id"
  end

  create_table "chat_users", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_chat_users_on_chat_id"
    t.index ["user_id"], name: "index_chat_users_on_user_id"
  end

  create_table "chats", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_chats_on_event_id"
  end

  create_table "collaborators", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_collaborators_on_event_id"
    t.index ["user_id"], name: "index_collaborators_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.date "date"
    t.integer "duration"
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_events_on_organization_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "invites", force: :cascade do |t|
    t.string "email", null: false
    t.string "invite_token", null: false
    t.datetime "expires_at", null: false
    t.boolean "used", default: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invite_token"], name: "index_invites_on_invite_token", unique: true
    t.index ["organization_id"], name: "index_invites_on_organization_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "chat_id", null: false
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "organization_users", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "user_id", null: false
    t.string "role", default: "user"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_users_on_organization_id"
    t.index ["user_id"], name: "index_organization_users_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "solid_cable_messages", force: :cascade do |t|
    t.text "channel"
    t.text "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel"], name: "index_solid_cable_messages_on_channel"
    t.index ["created_at"], name: "index_solid_cable_messages_on_created_at"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.datetime "created_at", null: false
    t.bigint "key_hash", null: false
    t.integer "byte_size", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.boolean "completed"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "event_id"
    t.bigint "activity_id"
    t.index ["activity_id"], name: "index_tasks_on_activity_id"
    t.index ["event_id"], name: "index_tasks_on_event_id"
  end

  create_table "tasks_users", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_tasks_users_on_task_id"
    t.index ["user_id"], name: "index_tasks_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "avatar_url", default: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities_events", "activities"
  add_foreign_key "activities_events", "events"
  add_foreign_key "chat_users", "chats"
  add_foreign_key "chat_users", "users"
  add_foreign_key "chats", "events"
  add_foreign_key "collaborators", "events"
  add_foreign_key "collaborators", "users"
  add_foreign_key "events", "organizations"
  add_foreign_key "events", "users"
  add_foreign_key "invites", "organizations"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "users"
  add_foreign_key "tasks", "activities"
  add_foreign_key "tasks", "events"
  add_foreign_key "tasks_users", "tasks"
  add_foreign_key "tasks_users", "users"
end
