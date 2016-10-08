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

ActiveRecord::Schema.define(version: 20161008051305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string   "company_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "phone_number"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "middle_name"
  end

  create_table "logs", force: :cascade do |t|
    t.string   "agent"
    t.string   "department"
    t.text     "comment"
    t.integer  "purchase_order_id"
    t.integer  "part_id"
    t.integer  "customer_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "logs", ["customer_id"], name: "index_logs_on_customer_id", using: :btree
  add_index "logs", ["part_id"], name: "index_logs_on_part_id", using: :btree
  add_index "logs", ["purchase_order_id"], name: "index_logs_on_purchase_order_id", using: :btree

  create_table "parts", force: :cascade do |t|
    t.string   "external_id"
    t.string   "part_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.string   "soid"
    t.date     "requested_ship_date"
    t.integer  "quantity"
    t.float    "unit_price"
    t.date     "estimated_ship_date"
    t.date     "revised_ship_date"
    t.integer  "customer_id"
    t.integer  "part_id"
    t.integer  "team_member_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "purchase_orders", ["customer_id"], name: "index_purchase_orders_on_customer_id", using: :btree
  add_index "purchase_orders", ["part_id"], name: "index_purchase_orders_on_part_id", using: :btree
  add_index "purchase_orders", ["team_member_id"], name: "index_purchase_orders_on_team_member_id", using: :btree

  create_table "team_members", force: :cascade do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "logs", "customers"
  add_foreign_key "logs", "parts"
  add_foreign_key "logs", "purchase_orders"
  add_foreign_key "purchase_orders", "customers"
  add_foreign_key "purchase_orders", "parts"
  add_foreign_key "purchase_orders", "team_members"
end
