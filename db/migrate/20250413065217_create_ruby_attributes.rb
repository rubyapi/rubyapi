class CreateRubyAttributes < ActiveRecord::Migration[8.0]
  def change
    create_table :ruby_attributes do |t|
      t.references :ruby_object, null: false, foreign_key: { on_delete: :cascade }
      t.string :name, null: false
      t.string :description
      t.string :access, default: "public"
      t.timestamps
    end
  end
end
