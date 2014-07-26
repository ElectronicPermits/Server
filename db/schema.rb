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

ActiveRecord::Schema.define(version: 20140726150517) do

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

  create_table "app_roles", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_roles_trusted_apps", id: false, force: true do |t|
    t.integer "app_role_id"
    t.integer "trusted_app_id"
  end

  create_table "companies", force: true do |t|
    t.string   "name"
    t.float    "average_rating"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consumers", force: true do |t|
    t.string   "unique_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trusted_app_id"
  end

  add_index "consumers", ["trusted_app_id"], name: "index_consumers_on_trusted_app_id"

  create_table "documents", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  create_table "people_vehicles", id: false, force: true do |t|
    t.integer "person_id"
    t.integer "vehicle_id"
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
  end

  create_table "ratings", force: true do |t|
    t.integer  "rating"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "consumer_id"
    t.integer  "permit_id"
  end

  add_index "ratings", ["consumer_id"], name: "index_ratings_on_consumer_id"
  add_index "ratings", ["permit_id"], name: "index_ratings_on_permit_id"

  create_table "service_types", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  add_index "services", ["consumer_id"], name: "index_services_on_consumer_id"
  add_index "services", ["permit_id"], name: "index_services_on_permit_id"

  create_table "trusted_apps", force: true do |t|
    t.string   "app_name"
    t.string   "description"
    t.string   "sha_hash"
    t.integer  "max_daily_posts", default: 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vehicles", force: true do |t|
    t.string   "make"
    t.string   "model"
    t.string   "color"
    t.string   "year"
    t.date     "inspection_date"
    t.string   "license_plate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "violations", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "ordinance"
    t.date     "issue_date"
    t.boolean  "closed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
