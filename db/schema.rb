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

ActiveRecord::Schema.define(version: 20171024153528) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aggregated_user_data", force: :cascade do |t|
    t.bigint "user_id"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_aggregated_user_data_on_user_id"
  end

  create_table "booking_guests", force: :cascade do |t|
    t.string "name"
    t.string "id_number"
    t.string "email"
    t.string "nationality"
    t.bigint "room_reservation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_reservation_id"], name: "index_booking_guests_on_room_reservation_id"
  end

  create_table "booking_invoices", force: :cascade do |t|
    t.bigint "reservation_id"
    t.integer "total"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_booking_invoices_on_reservation_id"
  end

  create_table "booking_prices", force: :cascade do |t|
    t.bigint "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.integer "one_guest"
    t.integer "two_guests"
    t.index ["room_id"], name: "index_booking_prices_on_room_id"
  end

  create_table "booking_reservations", force: :cascade do |t|
    t.bigint "user_id"
    t.date "start_date"
    t.date "end_date"
    t.integer "arrival_time"
    t.integer "status"
    t.text "special_details"
    t.string "pin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_booking_reservations_on_user_id"
  end

  create_table "booking_room_reservations", force: :cascade do |t|
    t.bigint "room_id"
    t.bigint "price_id"
    t.bigint "reservation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["price_id"], name: "index_booking_room_reservations_on_price_id"
    t.index ["reservation_id"], name: "index_booking_room_reservations_on_reservation_id"
    t.index ["room_id"], name: "index_booking_room_reservations_on_room_id"
  end

  create_table "booking_rooms", force: :cascade do |t|
    t.text "description"
    t.string "name"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "booking_status_change_messages", force: :cascade do |t|
    t.bigint "status_change_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_change_id"], name: "index_booking_status_change_messages_on_status_change_id"
  end

  create_table "booking_status_changes", force: :cascade do |t|
    t.integer "old_status"
    t.integer "new_status"
    t.string "object_type"
    t.bigint "object_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["object_type", "object_id"], name: "index_booking_status_changes_on_object_type_and_object_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.bigint "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "expanse_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "aggregated_user_data", "users"
  add_foreign_key "booking_guests", "booking_room_reservations", column: "room_reservation_id"
  add_foreign_key "booking_invoices", "booking_reservations", column: "reservation_id"
  add_foreign_key "booking_prices", "booking_rooms", column: "room_id"
  add_foreign_key "booking_reservations", "users"
  add_foreign_key "booking_room_reservations", "booking_prices", column: "price_id"
  add_foreign_key "booking_room_reservations", "booking_reservations", column: "reservation_id"
  add_foreign_key "booking_room_reservations", "booking_rooms", column: "room_id"
  add_foreign_key "booking_status_change_messages", "booking_status_changes", column: "status_change_id"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
end
