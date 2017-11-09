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

ActiveRecord::Schema.define(version: 20171109043602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "postgis"

  create_table "attachments", force: :cascade do |t|
    t.uuid     "tweet_id"
    t.integer  "media_attachment_id"
    t.integer  "index"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "flavor"
  end

  add_index "attachments", ["tweet_id"], name: "index_attachments_on_tweet_id", using: :btree

  create_table "mastodons", force: :cascade do |t|
    t.uuid     "tweet_id"
    t.integer  "status_id",  limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "mastodons", ["tweet_id"], name: "index_mastodons_on_tweet_id", using: :btree

  create_table "spatial_ref_sys", primary_key: "srid", force: :cascade do |t|
    t.string  "auth_name", limit: 256
    t.integer "auth_srid"
    t.string  "srtext",    limit: 2048
    t.string  "proj4text", limit: 2048
  end

# Could not dump table "tweets" because of following StandardError
#   Unknown type 'geography(Point,4326)' for column 'geo_point'

  add_foreign_key "attachments", "tweets"
  add_foreign_key "mastodons", "tweets"
end
