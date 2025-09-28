class CreateRubyRelease < ActiveRecord::Migration[8.0]
  def change
    create_table :ruby_releases do |t|
      t.string :version, null: false
      t.virtual :version_key,
        type: :integer,
        array: true,
        as: <<~SQL.squish,
          CASE
            WHEN version ~ '^[0-9]+.[0-9]+$' THEN string_to_array(version, '.')::int[]
          END
        SQL
        stored: true
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

    add_index :ruby_releases, :version_key, where: "version_key IS NOT NULL"
  end
end
