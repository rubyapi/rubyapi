class RubyObject < ApplicationRecord

  validates :name, :constant, :object_type, :version, presence: true

  belongs_to :ruby_methods

end
