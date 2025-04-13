class CreateRubyVersion < ActiveRecord::Migration[8.0]
  def change
    create_table :ruby_versions do |t|
      t.string :version, null: false
      t.string :url
      t.string :sha256
      t.string :git_branch
      t.string :git_tag
      t.boolean :signatures, default: false
      t.boolean :default, default: false
      t.boolean :eol, default: false
      t.boolean :prerelease, default: false
      t.timestamps

      t.index :version, unique: true
    end
  end
end
