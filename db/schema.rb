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

ActiveRecord::Schema[8.0].define(version: 2025_08_24_073447) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ruby_releases", force: :cascade do |t|
    t.string "version", null: false
    t.virtual "version_key", type: :integer, array: true, as: "\nCASE\n    WHEN ((version)::text ~ '^[0-9]+.[0-9]+$'::text) THEN (string_to_array((version)::text, '.'::text))::integer[]\n    ELSE NULL::integer[]\nEND", stored: true
    t.string "url"
    t.string "sha256"
    t.string "git_branch"
    t.string "git_tag"
    t.boolean "signatures", default: false
    t.boolean "default", default: false
    t.boolean "eol", default: false
    t.boolean "prerelease", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["version"], name: "index_ruby_releases_on_version", unique: true
    t.index ["version_key"], name: "index_ruby_releases_on_version_key", where: "(version_key IS NOT NULL)"
  end
end
