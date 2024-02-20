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

ActiveRecord::Schema[7.1].define(version: 2024_02_20_032839) do
  create_table "leagues", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "leagueName"
    t.string "leagueCode"
    t.integer "numberOfWeeks"
    t.integer "numberOfUsersNeeded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matchups", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "userOneId", null: false
    t.integer "userTwoId", null: false
    t.boolean "isActive", default: true, null: false
    t.boolean "isFinalized", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "league_id"
    t.integer "week"
    t.float "userOneDailyScore"
    t.float "userOneTotalScore"
    t.float "userTwoDailyScore"
    t.float "userTwoTotalScore"
    t.date "userOneScoreUpdated"
    t.date "userTwoScoreUpdated"
    t.date "endDate"
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
    t.boolean "default", default: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username"
    t.string "fname"
    t.string "lname"
    t.string "apple_game_center_id"
    t.string "jwt"
  end

  add_foreign_key "season_matchups", "seasons", on_delete: :cascade
  add_foreign_key "seasons", "matchups", on_delete: :cascade
end
