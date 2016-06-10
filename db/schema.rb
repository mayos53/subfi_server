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

ActiveRecord::Schema.define(version: 20150322211340) do

  create_table "events", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "group_id",   limit: 4
    t.integer  "time",       limit: 4
    t.integer  "event_type", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "administrator_id", limit: 4
    t.integer  "group_id",         limit: 4
    t.integer  "user_id",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "user_id",       limit: 4
    t.integer "group_id",      limit: 4
    t.boolean "administrator"
    t.integer "status",        limit: 4
  end

  create_table "push_configurations", force: :cascade do |t|
    t.string   "type",        limit: 255,                   null: false
    t.string   "app",         limit: 255,                   null: false
    t.text     "properties",  limit: 65535
    t.boolean  "enabled",                   default: false, null: false
    t.integer  "connections", limit: 4,     default: 1,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "push_feedback", force: :cascade do |t|
    t.string   "app",          limit: 255,                   null: false
    t.string   "device",       limit: 255,                   null: false
    t.string   "type",         limit: 255,                   null: false
    t.string   "follow_up",    limit: 255,                   null: false
    t.datetime "failed_at",                                  null: false
    t.boolean  "processed",                  default: false, null: false
    t.datetime "processed_at"
    t.text     "properties",   limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "push_feedback", ["processed"], name: "index_push_feedback_on_processed", using: :btree

  create_table "push_messages", force: :cascade do |t|
    t.string   "app",               limit: 255,                   null: false
    t.string   "device",            limit: 255,                   null: false
    t.string   "type",              limit: 255,                   null: false
    t.text     "properties",        limit: 65535
    t.boolean  "delivered",                       default: false, null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                          default: false, null: false
    t.datetime "failed_at"
    t.integer  "error_code",        limit: 4
    t.string   "error_description", limit: 255
    t.datetime "deliver_after"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "push_messages", ["delivered", "failed", "deliver_after"], name: "index_push_messages_on_delivered_and_failed_and_deliver_after", using: :btree

  create_table "recommendations", force: :cascade do |t|
    t.integer  "user_id",          limit: 4
    t.string   "user_name",        limit: 255
    t.integer  "group_id",         limit: 4
    t.string   "group_name",       limit: 255
    t.integer  "recommender_id",   limit: 4
    t.string   "recommender_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "administrator_id", limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string "name",           limit: 255
    t.text   "countryCode",    limit: 65535
    t.text   "phone",          limit: 65535
    t.text   "code",           limit: 65535
    t.string "email",          limit: 255
    t.string "registrationId", limit: 255
  end

  create_table "wallpapers", force: :cascade do |t|
    t.integer  "status",             limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id",           limit: 4
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size",    limit: 4
    t.datetime "photo_updated_at"
    t.string   "user_id",            limit: 255
    t.integer  "timeSec",            limit: 4
    t.string   "title",              limit: 255
  end

end
