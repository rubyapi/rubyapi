class RubyObject < ApplicationRecord

  validates :name, :constant, :object_type, :version, presence: true

end
