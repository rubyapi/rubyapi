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

ActiveRecord::Schema[8.0].define(version: 2025_04_13_070539) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ruby_attributes", force: :cascade do |t|
    t.bigint "ruby_object_id", null: false
    t.string "name", null: false
    t.string "description"
    t.string "access", default: "public"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ruby_object_id"], name: "index_ruby_attributes_on_ruby_object_id"
  end

  create_table "ruby_constants", force: :cascade do |t|
    t.bigint "ruby_object_id", null: false
    t.string "name", null: false
    t.string "description"
    t.string "constant"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ruby_object_id"], name: "index_ruby_constants_on_ruby_object_id"
  end

  create_table "ruby_gem_versions", force: :cascade do |t|
    t.bigint "ruby_gems_id", null: false
    t.string "version", null: false
    t.string "description"
    t.string "platform"
    t.boolean "prerelease", default: false
    t.boolean "yanked", default: false
    t.integer "downloads", default: 0
    t.string "sha"
    t.string "authors", default: [], array: true
    t.string "licenses", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ruby_gems_id"], name: "index_ruby_gem_versions_on_ruby_gems_id"
  end

  create_table "ruby_gems", force: :cascade do |t|
    t.string "name", null: false
    t.string "latest_version"
    t.integer "downloads", default: 0
    t.boolean "yanked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ruby_gems_on_name", unique: true
  end

  create_table "ruby_methods", force: :cascade do |t|
    t.bigint "ruby_object_id", null: false
    t.string "name", null: false
    t.string "description"
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
    t.bigint "ruby_version_id", null: false
    t.string "name", null: false
    t.string "path", null: false
    t.string "description"
    t.string "object_type"
    t.string "constant"
    t.string "superclass"
    t.string "included_modules", default: [], array: true
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ruby_objects_on_name"
    t.index ["path"], name: "index_ruby_objects_on_path"
    t.index ["ruby_version_id"], name: "index_ruby_objects_on_ruby_version_id"
  end

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

  add_foreign_key "ruby_attributes", "ruby_objects", on_delete: :cascade
  add_foreign_key "ruby_constants", "ruby_objects", on_delete: :cascade
  add_foreign_key "ruby_gem_versions", "ruby_gems", column: "ruby_gems_id"
  add_foreign_key "ruby_methods", "ruby_objects", on_delete: :cascade
  add_foreign_key "ruby_objects", "ruby_versions", on_delete: :cascade
end
