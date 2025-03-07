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

ActiveRecord::Schema[8.0].define(version: 2025_03_03_122912) do
  create_table "boosters", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "value", default: 5, null: false
    t.integer "x", null: false
    t.integer "y", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_boosters_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name", null: false
    t.integer "rows", default: 10, null: false
    t.integer "cols", default: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer "player_id"
    t.integer "game_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_messages_on_game_id"
    t.index ["player_id"], name: "index_messages_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer "game_id", null: false
    t.string "name", null: false
    t.integer "x", default: 0, null: false
    t.integer "y", default: 0, null: false
    t.integer "direction", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rotation", default: 0
    t.integer "score", default: 0
    t.index ["game_id", "name"], name: "index_players_on_game_id_and_name", unique: true
    t.index ["game_id"], name: "index_players_on_game_id"
    t.index ["name"], name: "index_players_on_name", unique: true
  end

  add_foreign_key "boosters", "games"
  add_foreign_key "players", "games"
end
