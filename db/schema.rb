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

ActiveRecord::Schema.define(version: 20161120000915) do

  create_table "accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "winery_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
    t.index ["winery_id"], name: "index_accounts_on_winery_id"
  end

  create_table "activities", force: :cascade do |t|
    t.string   "name"
    t.string   "activity_type"
    t.string   "activity_sub_type"
    t.integer  "winery_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["winery_id"], name: "index_activities_on_winery_id"
  end

  create_table "clubs", force: :cascade do |t|
    t.string   "name"
    t.integer  "winery_id"
    t.text     "description"
    t.string   "api_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["winery_id"], name: "index_clubs_on_winery_id"
  end

  create_table "deliveries", force: :cascade do |t|
    t.integer  "channel"
    t.integer  "activity_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["activity_id"], name: "index_deliveries_on_activity_id"
  end

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "club_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "registered"
    t.index ["club_id"], name: "index_memberships_on_club_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "sub_type"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "publications", force: :cascade do |t|
    t.integer  "winery_id"
    t.integer  "activity_id"
    t.string   "activity_type"
    t.datetime "launch_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["winery_id"], name: "index_publications_on_winery_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.integer  "order_id"
    t.datetime "ship_at"
    t.datetime "arrival_at"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "delivery_id"
    t.boolean  "activated"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["delivery_id"], name: "index_subscriptions_on_delivery_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "role"
    t.string   "authentication_token",   limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wineries", force: :cascade do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "api_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
