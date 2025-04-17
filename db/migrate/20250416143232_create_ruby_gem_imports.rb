class CreateRubyGemImports < ActiveRecord::Migration[8.0]
  def change
    create_table :ruby_gem_imports do |t|
      t.belongs_to :ruby_gem_version, null: false, foreign_key: { on_delete: :cascade }
      t.integer :status, default: 0
      t.string :error
      t.integer :retries, default: 0
      t.datetime :completed_at

      t.timestamps
    end
  end
end
