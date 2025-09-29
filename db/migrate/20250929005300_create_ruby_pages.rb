class CreateRubyPages < ActiveRecord::Migration[8.0]
  def change
    create_table :ruby_pages do |t|
      t.belongs_to :documentable, polymorphic: true
      t.string :name, null: false
      t.text :body
      t.jsonb :chapters, default: {}
      t.timestamps
    end
  end
end
