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

ActiveRecord::Schema.define(version: 2021_09_18_223650) do

  create_table "fifa_teams", force: :cascade do |t|
    t.string "name"
    t.string "stars"
    t.string "career"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "img"
  end

  create_table "games", force: :cascade do |t|
    t.string "round"
    t.integer "home_team_score"
    t.integer "away_team_score"
    t.integer "tournament_id", null: false
    t.integer "home_team_id"
    t.integer "away_team_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "home_fifa_team_id"
    t.string "away_fifa_team_id"
    t.index ["away_team_id"], name: "index_games_on_away_team_id"
    t.index ["home_team_id"], name: "index_games_on_home_team_id"
    t.index ["tournament_id"], name: "index_games_on_tournament_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "tournament_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tournament_id"], name: "index_teams_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.integer "pin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "tournament_created"
  end

  add_foreign_key "games", "tournaments"
  add_foreign_key "teams", "tournaments"
end
