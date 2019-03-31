class AddSourceFileToRubyMethods < ActiveRecord::Migration[5.2]
  def change
    add_column :ruby_methods, :source_location, :string, default: "", null: false
  end
end
