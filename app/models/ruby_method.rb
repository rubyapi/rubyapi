class RubyMethod < ApplicationRecord

  enum method_type: %i(instance_method class_method)

  validates :name, :method_type, :version, presence: true

  belongs_to :ruby_object

end
