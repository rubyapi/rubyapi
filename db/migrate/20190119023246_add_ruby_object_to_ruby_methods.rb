class AddRubyObjectToRubyMethods < ActiveRecord::Migration[5.2]
  def change
    add_reference :ruby_methods, :ruby_object, foreign_key: true
  end
end
