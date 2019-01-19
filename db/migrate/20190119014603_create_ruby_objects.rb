class CreateRubyObjects < ActiveRecord::Migration[5.2]
  def change
    create_table :ruby_objects do |t|
      t.integer :object_type
      t.string :name
      t.text :description
      t.string :version
      t.string :path
      t.string :constant

      t.timestamps
    end

    add_index :ruby_objects, [:path, :version]
  end
end
