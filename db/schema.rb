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

ActiveRecord::Schema.define(version: 2022_11_25_123944) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "card_type"
    t.string "card_type_text"
    t.string "code"
    t.boolean "is_used", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_cards_on_code", unique: true
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "lottery_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_real_name"
    t.string "user_mobile"
    t.string "user_email"
    t.integer "tiger_card_id"
    t.integer "rabbit_card_id"
    t.string "sn"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sn"], name: "index_lottery_records_on_sn"
    t.index ["user_id"], name: "index_lottery_records_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nick_name"
    t.string "avatar"
    t.string "open_id"
    t.string "unionid"
    t.string "session_key"
    t.string "real_name"
    t.string "mobile"
    t.string "email"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
