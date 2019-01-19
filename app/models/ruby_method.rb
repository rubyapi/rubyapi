class RubyMethod < ApplicationRecord

  validates :name, :method_type, :version, presence: true

  belongs_to :ruby_object

end
