class AddCallSeqToRubyMethods < ActiveRecord::Migration[5.2]
  def change
    add_column :ruby_methods, :call_sequence, :text, array: true, default: []
  end
end
