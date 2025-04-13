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

ActiveRecord::Schema[8.0].define(version: 2025_04_13_022851) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ruby_versions", force: :cascade do |t|
    t.string "version", null: false
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
    t.index ["version"], name: "index_ruby_versions_on_version", unique: true
  end
end
