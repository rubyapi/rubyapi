class RubyObject < ApplicationRecord
  include PathGenerator

  enum object_type: %i[module_object class_object]

  validates :name, :constant, :object_type, :version, presence: true

  has_many :ruby_methods
end
