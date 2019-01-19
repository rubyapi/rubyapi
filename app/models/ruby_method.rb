class RubyMethod < ApplicationRecord

  validates :name, :method_type, :version, presence: true

end
