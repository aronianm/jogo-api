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

ActiveRecord::Schema[7.1].define(version: 2024_02_11_054802) do
  create_table "leagues", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "leagueName"
    t.string "leagueCode"
    t.integer "numberOfWeeks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matchups", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "userOne", null: false
    t.integer "userTwo", null: false
    t.boolean "isActive", default: true, null: false
    t.boolean "isFinalized", default: false, null: false
    t.boolean "userAccepted"
    t.integer "createdBy", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "league_id"
  end

  create_table "season_matchups", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "week", default: 1, null: false
    t.bigint "season_id"
    t.boolean "startMatchup", default: true
    t.float "userOneDailyScore", default: 0.0, null: false
    t.float "userOneTotalScore", default: 0.0, null: false
    t.float "userTwoDailyScore", default: 0.0, null: false
    t.float "userTwoTotalScore", default: 0.0, null: false
    t.date "userOneScoreUpdated"
    t.date "userTwoScoreUpdated"
    t.date "endDate", null: false
    t.boolean "active"
    t.index ["season_id"], name: "fk_rails_66fd9bb5e4"
  end

  create_table "seasons", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "userOneWins", default: 0, null: false
    t.integer "userTwoWins", default: 0, null: false
    t.bigint "matchup_id"
    t.integer "active", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "league_id"
    t.index ["matchup_id"], name: "fk_rails_a523f1a9da"
  end

  create_table "user_leagues", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id"
    t.integer "wins"
    t.integer "losses"
    t.integer "league_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "fname"
    t.string "lname"
    t.string "email", default: ""
    t.string "phone_number", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "season_matchups", "seasons", on_delete: :cascade
  add_foreign_key "seasons", "matchups", on_delete: :cascade
end
