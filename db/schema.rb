# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141011133910) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "uuid-ossp"

  create_table "spatial_ref_sys", primary_key: "srid", force: true do |t|
    t.string  "auth_name", limit: 256
    t.integer "auth_srid"
    t.string  "srtext",    limit: 2048
    t.string  "proj4text", limit: 2048
  end

  create_table "tweets", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "id_str"
    t.string   "text"
    t.json     "body"
    t.decimal  "id_number"
    t.datetime "created_at"
    t.integer  "geo_point",                  limit: 0
    t.string   "default_image_file_name"
    t.string   "default_image_content_type"
    t.integer  "default_image_file_size"
    t.datetime "default_image_updated_at"
    t.string   "retweeted_status_id"
    t.string   "in_reply_to_status_id"
  end

  add_index "tweets", ["geo_point"], name: "index_tweets_on_geo_point", using: :gist
  add_index "tweets", ["id_number"], name: "index_tweets_on_id_number", unique: true, using: :btree
  add_index "tweets", ["in_reply_to_status_id"], name: "index_tweets_on_in_reply_to_status_id", using: :btree
  add_index "tweets", ["retweeted_status_id"], name: "index_tweets_on_retweeted_status_id", using: :btree

end
