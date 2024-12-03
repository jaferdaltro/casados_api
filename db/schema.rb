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

ActiveRecord::Schema[7.2].define(version: 2024_12_03_005654) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_accounts_on_uuid", unique: true
  end

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

  create_table "charges", force: :cascade do |t|
    t.decimal "value", precision: 5, scale: 2
    t.string "billing_type"
    t.string "status"
    t.string "description"
    t.decimal "discount"
    t.string "credit_card_number"
    t.string "credit_card_brand"
    t.integer "user_id"
    t.string "charge_id"
    t.string "customer_id"
    t.date "due_date"
    t.string "payment_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "marriages", force: :cascade do |t|
    t.integer "husband_id"
    t.integer "wife_id"
    t.boolean "is_member"
    t.string "campus"
    t.text "reason"
    t.boolean "active", default: false
    t.string "religion"
    t.integer "children_quantity"
    t.text "days_availability", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["husband_id", "wife_id"], name: "index_marriages_on_husband_id_and_wife_id", unique: true
    t.index ["husband_id"], name: "index_marriages_on_husband_id"
    t.index ["wife_id"], name: "index_marriages_on_wife_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.string "role", limit: 16, null: false
    t.bigint "user_id", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "user_id"], name: "index_memberships_on_account_id_and_user_id", unique: true
    t.index ["account_id"], name: "index_memberships_on_account_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "amount"
    t.integer "payment_method"
    t.integer "status"
    t.date "due_date"
    t.string "asaas_payment_id"
    t.string "card_holder_name"
    t.string "card_number"
    t.string "card_expiry_month"
    t.string "card_expiry_year"
    t.string "card_cvv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_payments_on_user_id"
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
    t.string "gender"
    t.string "password_digest", null: false
    t.date "birth_at"
    t.string "t_shirt_size"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "address_id"
    t.string "asaas_customer_id"
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

  add_foreign_key "memberships", "accounts"
  add_foreign_key "memberships", "users"
  add_foreign_key "payments", "users"
  add_foreign_key "user_tokens", "users"
  add_foreign_key "users", "addresses"
end
