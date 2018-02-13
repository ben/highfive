# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180213140852) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fundings", force: :cascade do |t|
    t.bigint "slack_team_id"
    t.bigint "highfive_record_id"
    t.integer "amount"
    t.string "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["highfive_record_id"], name: "index_fundings_on_highfive_record_id"
    t.index ["slack_team_id"], name: "index_fundings_on_slack_team_id"
  end

  create_table "highfive_records", id: :serial, force: :cascade do |t|
    t.integer "slack_team_id"
    t.string "from"
    t.string "to"
    t.string "reason"
    t.string "currency"
    t.float "amount"
    t.string "card_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slack_response_url"
    t.string "tango_reference_order_id"
    t.string "state"
    t.string "tango_payload"
    t.index ["slack_team_id"], name: "index_highfive_records_on_slack_team_id"
  end

  create_table "slack_teams", id: :serial, force: :cascade do |t|
    t.string "team_id"
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tango_customer_identifier"
    t.string "tango_account_identifier"
    t.string "tango_card_token"
    t.string "team_name"
    t.string "team_subdomain"
    t.integer "award_limit"
    t.integer "daily_limit"
    t.integer "double_rate"
    t.integer "boomerang_rate"
    t.index ["team_id"], name: "index_slack_teams_on_team_id", unique: true
  end

  add_foreign_key "fundings", "highfive_records"
  add_foreign_key "fundings", "slack_teams"
  add_foreign_key "highfive_records", "slack_teams"
end
