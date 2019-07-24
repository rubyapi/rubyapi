# frozen_string_literal: true

class RubyMethod < ApplicationRecord
  searchkick searchable: [:name, :description, :parent_name], filterable: [:version, :name, :parent_name, :method_type]

  enum method_type: %i[instance_method class_method]

  validates :name, :method_type, :version, presence: true

  belongs_to :ruby_object

  scope :ordered, -> { order :name }

  attribute :parent_name, :string

  def type_identifier
    if instance_method?
      "#"
    elsif class_method?
      "::"
    end
  end

  def parent_name
    ruby_object.name
  end
end
