class CreateRubyObjects < ActiveRecord::Migration[8.0]
  def change
    create_table :ruby_objects do |t|
      t.belongs_to :documentable, polymorphic: true
      t.string :name, null: false
      t.string :path, null: false
      t.text :description
      t.string :object_type, null: false
      t.string :constant, null: false
      t.string :superclass
      t.string :included_modules, array: true, default: []
      t.jsonb :metadata, default: {}
      t.timestamps
    end
  end
end
