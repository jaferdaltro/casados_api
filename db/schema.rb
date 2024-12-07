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

ActiveRecord::Schema[7.2].define(version: 2024_11_11_170837) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.integer "number"
    t.string "neighborhood"
    t.string "cep"
    t.string "city"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["neighborhood"], name: "index_addresses_on_neighborhood"
    t.index ["street"], name: "index_addresses_on_street"
  end

  create_table "marriages", force: :cascade do |t|
    t.integer "husband_id"
    t.integer "wife_id"
    t.string "registered_by"
    t.boolean "dinner_participation", default: false
    t.text "reason"
    t.boolean "is_member"
    t.string "campus"
    t.string "religion"
    t.boolean "active", default: false
    t.integer "children_quantity"
    t.text "days_availability", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["husband_id", "wife_id"], name: "index_marriages_on_husband_id_and_wife_id", unique: true
    t.index ["husband_id"], name: "index_marriages_on_husband_id"
    t.index ["wife_id"], name: "index_marriages_on_wife_id"
  end

  create_table "student_subscriptions", force: :cascade do |t|
    t.integer "marriage_id"
    t.integer "voucher_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_tokens", force: :cascade do |t|
    t.string "access_token", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_user_tokens_on_access_token", unique: true
    t.index ["user_id"], name: "index_user_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "phone", null: false
    t.string "cpf"
    t.string "email"
    t.date "birth_at"
    t.integer "role", default: 0
    t.string "gender"
    t.string "t_shirt_size"
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "address_id"
    t.index ["address_id"], name: "index_users_on_address_id"
    t.index ["phone"], name: "index_users_on_phone", unique: true
  end

  create_table "vouchers", force: :cascade do |t|
    t.string "code", null: false
    t.boolean "is_available", default: true
    t.datetime "expiration_at", null: false
    t.integer "user_id", null: false
    t.integer "lives", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_vouchers_on_code", unique: true
  end

  add_foreign_key "user_tokens", "users"
  add_foreign_key "users", "addresses"
end
