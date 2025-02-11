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

ActiveRecord::Schema[7.2].define(version: 2025_02_11_133721) do
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
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "lng", precision: 10, scale: 6
    t.index ["neighborhood"], name: "index_addresses_on_neighborhood"
    t.index ["street"], name: "index_addresses_on_street"
  end

  create_table "classroom_students", force: :cascade do |t|
    t.bigint "classroom_id", null: false
    t.bigint "marriage_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id", "marriage_id"], name: "index_classroom_students_on_classroom_id_and_marriage_id", unique: true
    t.index ["classroom_id"], name: "index_classroom_students_on_classroom_id"
    t.index ["marriage_id"], name: "index_classroom_students_on_marriage_id"
  end

  create_table "classrooms", force: :cascade do |t|
    t.bigint "leader_marriage_id", null: false
    t.integer "address_id"
    t.string "weekday"
    t.string "class_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "semester"
    t.boolean "active", default: false
    t.integer "co_leader_marriage_id"
    t.index ["leader_marriage_id"], name: "index_classrooms_on_leader_marriage_id"
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
    t.string "uuid"
    t.integer "address_id"
    t.boolean "pastoral_indication", default: false
    t.string "id_asaas"
    t.boolean "messaged", default: false
    t.index ["address_id"], name: "index_marriages_on_address_id"
    t.index ["husband_id", "wife_id"], name: "index_marriages_on_husband_id_and_wife_id", unique: true
    t.index ["husband_id"], name: "index_marriages_on_husband_id"
    t.index ["wife_id"], name: "index_marriages_on_wife_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.text "description"
    t.boolean "sended", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "marriage_id", null: false
    t.string "asaas_client_id"
    t.string "description"
    t.decimal "amount"
    t.integer "payment_method"
    t.integer "status"
    t.date "due_date"
    t.string "asaas_payment_id"
    t.string "qr_code"
    t.string "card_holder_name"
    t.string "card_number"
    t.string "card_expiry_month"
    t.string "card_expiry_year"
    t.string "card_cvv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.index ["marriage_id"], name: "index_payments_on_marriage_id"
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
    t.integer "gender"
    t.string "t_shirt_size"
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_token"
    t.string "remember_digest"
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

  add_foreign_key "classroom_students", "classrooms"
  add_foreign_key "classroom_students", "marriages"
  add_foreign_key "classrooms", "marriages", column: "leader_marriage_id"
  add_foreign_key "payments", "marriages"
  add_foreign_key "user_tokens", "users"
end
