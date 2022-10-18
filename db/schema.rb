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

ActiveRecord::Schema.define(version: 2022_10_17_051008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "anniversaries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.datetime "date", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_anniversaries_on_user_id"
  end

  create_table "letters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "template_id"
    t.string "title", null: false
    t.text "body", null: false
    t.string "image"
    t.text "token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "send_date", null: false
    t.index ["template_id"], name: "index_letters_on_template_id"
    t.index ["user_id"], name: "index_letters_on_user_id"
  end

  create_table "send_letters", force: :cascade do |t|
    t.integer "destination_id", null: false
    t.bigint "letter_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["destination_id"], name: "index_send_letters_on_destination_id"
    t.index ["letter_id"], name: "index_send_letters_on_letter_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "name", null: false
    t.string "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "line_user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role", default: 0, null: false
    t.index ["line_user_id"], name: "index_users_on_line_user_id", unique: true
  end

  add_foreign_key "anniversaries", "users"
  add_foreign_key "letters", "templates"
  add_foreign_key "letters", "users"
  add_foreign_key "send_letters", "letters"
  add_foreign_key "send_letters", "users", column: "destination_id"
end
