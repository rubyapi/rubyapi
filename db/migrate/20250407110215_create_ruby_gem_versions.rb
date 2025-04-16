class CreateRubyGemVersions < ActiveRecord::Migration[8.0]
  def change
    create_table :ruby_gem_versions do |t|
      t.references :ruby_gems, null: false, foreign_key: true
      t.string :version, null: false
      t.string :description
      t.string :platform
      t.boolean :prerelease, default: false
      t.boolean :yanked, default: false
      t.integer :downloads, default: 0
      t.string :sha
      t.string :authors, array: true, default: []
      t.string :licenses, array: true, default: []
      t.timestamps
    end
  end
end
