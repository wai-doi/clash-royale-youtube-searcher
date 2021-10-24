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

ActiveRecord::Schema.define(version: 2021_10_24_152254) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buildings", force: :cascade do |t|
    t.bigint "deck_id", null: false
    t.bigint "card_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_buildings_on_card_id"
    t.index ["deck_id", "card_id"], name: "index_buildings_on_deck_id_and_card_id", unique: true
    t.index ["deck_id"], name: "index_buildings_on_deck_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_cards_on_name", unique: true
  end

  create_table "decks", force: :cascade do |t|
    t.string "sorted_card_names", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sorted_card_names"], name: "index_decks_on_sorted_card_names", unique: true
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "stats_royale_video_id", null: false
    t.bigint "deck_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deck_id"], name: "index_matches_on_deck_id"
    t.index ["stats_royale_video_id"], name: "index_matches_on_stats_royale_video_id"
  end

  create_table "stats_royale_videos", force: :cascade do |t|
    t.string "youtube_video_id", null: false
    t.datetime "published_at", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.string "thumbnail_url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["youtube_video_id"], name: "index_stats_royale_videos_on_youtube_video_id", unique: true
  end

  add_foreign_key "buildings", "cards"
  add_foreign_key "buildings", "decks"
  add_foreign_key "matches", "decks"
  add_foreign_key "matches", "stats_royale_videos"
end
