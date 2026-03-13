class CreateRubyAttributes < ActiveRecord::Migration[8.0]
  def change
    create_table :ruby_attributes do |t|
      t.belongs_to :ruby_object, index: true, foreign_key: { on_delete: :cascade }
      t.string :name, null: false
      t.text :description
      t.string :access, default: "rw"
      t.timestamps
    end
  end
end
