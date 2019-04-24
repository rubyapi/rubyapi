class RubyMethod < ApplicationRecord
  searchkick searchable: [:name, :description, :method_parent], filterable: [:version, :name, :method_parent]

  enum method_type: %i[instance_method class_method]

  validates :name, :method_type, :version, presence: true

  belongs_to :ruby_object

  scope :ordered, -> { order :name }

  attribute :method_parent, :string

  def method_parent
    ruby_object.name
  end

  def anchor
    if instance_method?
      "method-i-#{name}"
    elsif class_method?
      "method-c-#{name}"
    end
  end
end
