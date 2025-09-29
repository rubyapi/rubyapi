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

ActiveRecord::Schema[8.0].define(version: 2025_09_29_002850) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ruby_attributes", force: :cascade do |t|
    t.bigint "ruby_object_id"
    t.string "name", null: false
    t.text "description"
    t.string "access", default: "rw"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ruby_object_id"], name: "index_ruby_attributes_on_ruby_object_id"
  end

  create_table "ruby_constants", force: :cascade do |t|
    t.bigint "ruby_object_id"
    t.string "name", null: false
    t.text "description"
    t.string "constant", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ruby_object_id"], name: "index_ruby_constants_on_ruby_object_id"
  end

  create_table "ruby_methods", force: :cascade do |t|
    t.bigint "ruby_object_id"
    t.string "name", null: false
    t.text "description"
    t.string "method_type"
    t.string "source_location"
    t.string "constant"
    t.string "call_sequences", default: [], array: true
    t.string "source_body"
    t.string "method_alias"
    t.string "signatures", default: [], array: true
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ruby_object_id"], name: "index_ruby_methods_on_ruby_object_id"
  end

  create_table "ruby_objects", force: :cascade do |t|
    t.string "documentable_type"
    t.bigint "documentable_id"
    t.string "name", null: false
    t.string "path", null: false
    t.text "description"
    t.string "object_type", null: false
    t.string "constant", null: false
    t.string "superclass"
    t.string "included_modules", default: [], array: true
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["documentable_type", "documentable_id"], name: "index_ruby_objects_on_documentable"
  end

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

  add_foreign_key "ruby_attributes", "ruby_objects", on_delete: :cascade
  add_foreign_key "ruby_constants", "ruby_objects", on_delete: :cascade
  add_foreign_key "ruby_methods", "ruby_objects", on_delete: :cascade
end
