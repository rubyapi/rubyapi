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

ActiveRecord::Schema.define(version: 2019_03_31_061312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ruby_methods", force: :cascade do |t|
    t.string "name"
    t.integer "method_type"
    t.text "description"
    t.string "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ruby_object_id"
    t.text "call_sequence", default: [], array: true
    t.string "source_location", default: "", null: false
    t.index ["ruby_object_id"], name: "index_ruby_methods_on_ruby_object_id"
  end

  create_table "ruby_objects", force: :cascade do |t|
    t.integer "object_type"
    t.string "name"
    t.text "description"
    t.string "version"
    t.string "path"
    t.string "constant"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source_location", default: ""
    t.index ["path", "version"], name: "index_ruby_objects_on_path_and_version"
  end

  add_foreign_key "ruby_methods", "ruby_objects"
end
