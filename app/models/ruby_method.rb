# frozen_string_literal: true

class RubyMethod < ApplicationRecord
  searchkick searchable: [:name, :description, :method_parent], filterable: [:version, :name, :method_parent, :method_type]

  enum method_type: %i[instance_method class_method]

  validates :name, :method_type, :version, presence: true

  belongs_to :ruby_object

  scope :ordered, -> { order :name }
end
