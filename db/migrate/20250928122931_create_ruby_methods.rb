class CreateRubyMethods < ActiveRecord::Migration[8.0]
  def change
    create_table :ruby_methods do |t|
      t.belongs_to :ruby_object, index: true, foreign_key: {on_delete: :cascade}
      t.string :name, null: false
      t.text :description
      t.string :method_type
      t.string :source_location
      t.string :constant
      t.string :call_sequences, array: true, default: []
      t.string :source_body
      t.string :method_alias
      t.string :signatures, array: true, default: []
      t.jsonb :metadata, default: {}
      t.timestamps
    end
  end
end
