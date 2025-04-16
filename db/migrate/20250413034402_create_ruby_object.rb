class CreateRubyObject < ActiveRecord::Migration[8.0]
  def change
    create_table :ruby_objects do |t|
      t.belongs_to :ruby_version, index: true, foreign_key: { on_delete: :cascade }
      t.string :name, null: false
      t.string :path, null: false
      t.string :description
      t.string :object_type
      t.string :constant
      t.string :superclass
      t.string :included_modules, array: true, default: []
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :ruby_objects, :name
    add_index :ruby_objects, :path
  end
end
