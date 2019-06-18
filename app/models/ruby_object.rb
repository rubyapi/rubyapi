# frozen_string_literal: true

class RubyObject < ApplicationRecord
  include PathGenerator

  searchkick searchable: [:name, :description], filterable: [:version, :name]

  enum object_type: %i[module_object class_object]

  validates :name, :constant, :object_type, :version, presence: true

  has_many :ruby_methods

  def to_param
    path
  end
end
