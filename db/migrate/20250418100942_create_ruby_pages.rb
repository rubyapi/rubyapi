class CreateRubyPages < ActiveRecord::Migration[8.0]
  def change
    create_table :ruby_pages do |t|
      t.belongs_to :ruby_version, index: true, foreign_key: { on_delete: :cascade }
      t.belongs_to :ruby_gem_version, index: true, foreign_key: { on_delete: :cascade }
      t.string :name
      t.string :body
      t.timestamps
    end

    add_index :ruby_pages, :name
  end
end
