class IndexRubyGemDownloads < ActiveRecord::Migration[8.0]
  def change
    add_index :ruby_gems, [ :downloads ]
  end
end
