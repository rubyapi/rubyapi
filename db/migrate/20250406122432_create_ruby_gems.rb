class CreateRubyGems < ActiveRecord::Migration[8.0]
  def change
    create_table :ruby_gems do |t|
      t.string :name, null: false
      t.string :latest_version
      t.integer :downloads, default: 0
      t.boolean :yanked, default: false
      t.timestamps

      t.index :name, unique: true
    end
  end
end
