class CreateRubyMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :ruby_methods do |t|
      t.string :name
      t.integer :method_type
      t.text :description
      t.string :version

      t.timestamps
    end
  end
end
