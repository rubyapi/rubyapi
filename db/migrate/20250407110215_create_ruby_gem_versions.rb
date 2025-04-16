class CreateRubyGemVersions < ActiveRecord::Migration[8.0]
  def change
    create_table :ruby_gem_versions do |t|
      t.belongs_to :ruby_gem, index: true, foreign_key: { on_delete: :cascade }
      t.string :version, null: false
      t.string :description
      t.string :summary
      t.string :platform
      t.boolean :prerelease, default: false
      t.boolean :yanked, default: false
      t.integer :downloads, default: 0
      t.string :sha256
      t.string :authors
      t.string :licenses, array: true, default: []
      t.datetime :published_at
      t.datetime :built_at
      t.jsonb :metadata, default: {}
      t.timestamps
    end

    add_index :ruby_gem_versions, [ :ruby_gem_id, :version ], unique: true
  end
end
