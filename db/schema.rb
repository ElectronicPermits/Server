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

ActiveRecord::Schema.define(version: 20141226192338) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "line1"
    t.string   "line2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.float    "average_rating", default: 0.0
    t.float    "total_ratings",  default: 0.0
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trusted_app_id"
  end

  add_index "companies", ["trusted_app_id"], name: "index_companies_on_trusted_app_id", using: :btree

  create_table "consumers", force: true do |t|
    t.string   "unique_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trusted_app_id"
  end

  add_index "consumers", ["trusted_app_id"], name: "index_consumers_on_trusted_app_id", using: :btree

  create_table "people", force: true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "race"
    t.string   "sex"
    t.integer  "height"
    t.integer  "weight"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trusted_app_id"
    t.integer  "company_id"
  end

  add_index "people", ["company_id"], name: "index_people_on_company_id", using: :btree
  add_index "people", ["trusted_app_id"], name: "index_people_on_trusted_app_id", using: :btree

  create_table "people_vehicles", id: false, force: true do |t|
    t.integer "person_id"
    t.integer "vehicle_id"
  end

  create_table "permissions", force: true do |t|
    t.integer  "permission_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service_type_id"
  end

  add_index "permissions", ["service_type_id"], name: "index_permissions_on_service_type_id", using: :btree

  create_table "permissions_trusted_apps", id: false, force: true do |t|
    t.integer "permission_id"
    t.integer "trusted_app_id"
  end

  create_table "permits", force: true do |t|
    t.string   "permit_number"
    t.date     "permit_expiration_date"
    t.date     "training_completion_date"
    t.string   "status"
    t.boolean  "valid",                    default: true
    t.string   "beacon_id"
    t.float    "average_rating",           default: 0.0
    t.integer  "total_ratings",            default: 0
    t.integer  "permitable_id"
    t.string   "permitable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trusted_app_id"
    t.integer  "service_type_id"
  end

  add_index "permits", ["permitable_id", "permitable_type"], name: "index_permits_on_permitable_id_and_permitable_type", using: :btree
  add_index "permits", ["trusted_app_id"], name: "index_permits_on_trusted_app_id", using: :btree

  create_table "ratings", force: true do |t|
    t.integer  "rating"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "consumer_id"
    t.integer  "permit_id"
  end

  add_index "ratings", ["consumer_id"], name: "index_ratings_on_consumer_id", using: :btree
  add_index "ratings", ["permit_id"], name: "index_ratings_on_permit_id", using: :btree

  create_table "service_types", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trusted_app_id"
  end

  add_index "service_types", ["trusted_app_id"], name: "index_service_types_on_trusted_app_id", using: :btree

  create_table "services", force: true do |t|
    t.float    "start_latitude"
    t.float    "start_longitude"
    t.float    "end_latitude"
    t.float    "end_longitude"
    t.time     "start_time"
    t.time     "end_time"
    t.decimal  "estimated_cost"
    t.decimal  "actual_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "permit_id"
    t.integer  "consumer_id"
  end

  add_index "services", ["consumer_id"], name: "index_services_on_consumer_id", using: :btree
  add_index "services", ["permit_id"], name: "index_services_on_permit_id", using: :btree

  create_table "static_permissions", force: true do |t|
    t.integer  "permission_type"
    t.integer  "target"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "static_permissions_trusted_apps", id: false, force: true do |t|
    t.integer "static_permission_id"
    t.integer "trusted_app_id"
  end

  create_table "trusted_apps", force: true do |t|
    t.string   "app_name"
    t.string   "description"
    t.string   "sha_hash"
    t.integer  "max_daily_posts", default: 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact_name"
    t.string   "contact_email"
  end

  create_table "user_permissions", force: true do |t|
    t.integer  "action"
    t.integer  "target"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_permissions_users", id: false, force: true do |t|
    t.integer "user_permission_id"
    t.integer "user_id"
  end

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vehicles", force: true do |t|
    t.string   "make"
    t.string   "model"
    t.string   "color"
    t.string   "year"
    t.date     "inspection_date"
    t.string   "license_plate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trusted_app_id"
  end

  add_index "vehicles", ["trusted_app_id"], name: "index_vehicles_on_trusted_app_id", using: :btree

  create_table "violations", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "ordinance"
    t.date     "issue_date"
    t.boolean  "closed",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "permit_id"
    t.integer  "trusted_app_id"
  end

  add_index "violations", ["permit_id"], name: "index_violations_on_permit_id", using: :btree
  add_index "violations", ["trusted_app_id"], name: "index_violations_on_trusted_app_id", using: :btree

end
