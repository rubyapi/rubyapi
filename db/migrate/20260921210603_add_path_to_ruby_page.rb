class AddPathToRubyPage < ActiveRecord::Migration[8.1]
  def change
    change_table :ruby_pages do |t|
      t.string :path, null: false
    end
  end
end
