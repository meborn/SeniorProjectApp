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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150411193928) do

  create_table "appointments", force: true do |t|
    t.datetime "start"
    t.datetime "end"
    t.integer  "profile_id"
    t.integer  "owner_id"
    t.integer  "client_id"
  end

  add_index "appointments", ["client_id"], name: "index_appointments_on_client_id"
  add_index "appointments", ["owner_id"], name: "index_appointments_on_owner_id"
  add_index "appointments", ["profile_id"], name: "index_appointments_on_profile_id"

  create_table "clients", force: true do |t|
    t.integer "client_id"
    t.integer "owner_id"
    t.boolean "approved",   default: false
    t.integer "profile_id"
  end

  add_index "clients", ["client_id"], name: "index_clients_on_client_id"
  add_index "clients", ["owner_id"], name: "index_clients_on_owner_id"
  add_index "clients", ["profile_id"], name: "index_clients_on_profile_id"

  create_table "notifications", force: true do |t|
    t.integer "user_id"
    t.integer "event"
    t.integer "event_type"
    t.boolean "seen",       default: false
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id"

  create_table "openings", force: true do |t|
    t.datetime "start"
    t.datetime "end"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
  end

  add_index "openings", ["profile_id"], name: "index_openings_on_profile_id"
  add_index "openings", ["user_id"], name: "index_openings_on_user_id"

  create_table "profiles", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "wallpaper_file_name"
    t.string   "wallpaper_content_type"
    t.integer  "wallpaper_file_size"
    t.datetime "wallpaper_updated_at"
    t.string   "zip"
    t.string   "city"
    t.string   "state"
    t.string   "color"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
