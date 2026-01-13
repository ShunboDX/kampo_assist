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

ActiveRecord::Schema[8.1].define(version: 2026_01_13_061823) do
  create_table "authorizations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["provider", "uid"], name: "index_authorizations_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_authorizations_on_user_id"
  end

  create_table "case_notes", force: :cascade do |t|
    t.text "body", default: "", null: false
    t.datetime "created_at", null: false
    t.integer "kampo_id"
    t.integer "search_session_id"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["kampo_id"], name: "index_case_notes_on_kampo_id"
    t.index ["search_session_id"], name: "index_case_notes_on_search_session_id"
    t.index ["user_id"], name: "index_case_notes_on_user_id"
  end

  create_table "diseases", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "medical_area_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["medical_area_id"], name: "index_diseases_on_medical_area_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "kampo_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["kampo_id"], name: "index_favorites_on_kampo_id"
    t.index ["user_id", "kampo_id"], name: "index_favorites_on_user_id_and_kampo_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "kampo_diseases", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "disease_id", null: false
    t.integer "kampo_id", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 1, null: false
    t.index ["disease_id"], name: "index_kampo_diseases_on_disease_id"
    t.index ["kampo_id"], name: "index_kampo_diseases_on_kampo_id"
  end

  create_table "kampo_symptoms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "kampo_id", null: false
    t.integer "symptom_id", null: false
    t.datetime "updated_at", null: false
    t.integer "weight"
    t.index ["kampo_id"], name: "index_kampo_symptoms_on_kampo_id"
    t.index ["symptom_id"], name: "index_kampo_symptoms_on_symptom_id"
  end

  create_table "kampos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "detail"
    t.string "kana_name", null: false
    t.string "name", null: false
    t.string "note"
    t.datetime "updated_at", null: false
  end

  create_table "medical_areas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "display_order", default: 0, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "search_sessions", force: :cascade do |t|
    t.json "conditions", null: false
    t.string "conditions_hash", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "conditions_hash"], name: "index_search_sessions_on_user_id_and_conditions_hash", unique: true
    t.index ["user_id"], name: "index_search_sessions_on_user_id"
  end

  create_table "symptoms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "medical_area_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["medical_area_id"], name: "index_symptoms_on_medical_area_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "crypted_password"
    t.string "email", null: false
    t.string "salt"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "authorizations", "users"
  add_foreign_key "case_notes", "kampos"
  add_foreign_key "case_notes", "search_sessions"
  add_foreign_key "case_notes", "users"
  add_foreign_key "diseases", "medical_areas"
  add_foreign_key "favorites", "kampos"
  add_foreign_key "favorites", "users"
  add_foreign_key "kampo_diseases", "diseases"
  add_foreign_key "kampo_diseases", "kampos"
  add_foreign_key "kampo_symptoms", "kampos"
  add_foreign_key "kampo_symptoms", "symptoms"
  add_foreign_key "search_sessions", "users"
  add_foreign_key "symptoms", "medical_areas"
end
