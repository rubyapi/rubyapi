class RubyObject < ApplicationRecord
  has_many :ruby_methods, dependent: :destroy
  has_many :ruby_attributes, dependent: :destroy
  has_many :ruby_constants, dependent: :destroy

  def class_object?
    object_type == "class"
  end

  def module_object?
    object_type == "module"
  end
end
