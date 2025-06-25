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

ActiveRecord::Schema[8.0].define(version: 2025_06_24_202505) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.string "stripe_customer_id"
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_checkout_session_id"
    t.string "stripe_payment_intent_id"
    t.string "payment_status", default: "pending"
    t.integer "amount_paid"
    t.datetime "paid_at"
    t.boolean "confirmed"
    t.index ["event_id"], name: "index_attendances_on_event_id"
    t.index ["payment_status"], name: "index_attendances_on_payment_status"
    t.index ["stripe_checkout_session_id"], name: "index_attendances_on_stripe_checkout_session_id"
    t.index ["stripe_payment_intent_id"], name: "index_attendances_on_stripe_payment_intent_id"
    t.index ["user_id", "event_id"], name: "index_attendances_on_user_and_event", unique: true
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "start_date"
    t.integer "duration"
    t.integer "price"
    t.string "location"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "validated"
    t.boolean "reviewed", default: false, null: false
    t.text "admin_comment"
    t.datetime "validated_at"
    t.integer "validated_by_id"
    t.index ["reviewed"], name: "index_events_on_reviewed"
    t.index ["user_id"], name: "index_events_on_user_id"
    t.index ["validated", "reviewed"], name: "index_events_on_validated_and_reviewed"
    t.index ["validated"], name: "index_events_on_validated"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.bigint "attendance_id"
    t.string "stripe_checkout_session_id", null: false
    t.string "stripe_payment_intent_id"
    t.string "stripe_customer_id"
    t.integer "amount", null: false
    t.string "currency", default: "eur"
    t.string "status", default: "pending"
    t.text "stripe_metadata"
    t.datetime "paid_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendance_id"], name: "index_payments_on_attendance_id"
    t.index ["event_id"], name: "index_payments_on_event_id"
    t.index ["status"], name: "index_payments_on_status"
    t.index ["stripe_checkout_session_id"], name: "index_payments_on_stripe_checkout_session_id", unique: true
    t.index ["stripe_payment_intent_id"], name: "index_payments_on_stripe_payment_intent_id"
    t.index ["user_id", "event_id"], name: "index_payments_on_user_id_and_event_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.text "description"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false, null: false
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attendances", "events"
  add_foreign_key "attendances", "users"
  add_foreign_key "events", "users"
  add_foreign_key "events", "users", column: "validated_by_id"
  add_foreign_key "payments", "attendances"
  add_foreign_key "payments", "events"
  add_foreign_key "payments", "users"
end
