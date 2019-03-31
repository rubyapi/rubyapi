class AddSourceLocationToRubyObject < ActiveRecord::Migration[5.2]
  def change
    add_column :ruby_objects, :source_location, :string, default: ""
  end
end
