class RubyObject < ApplicationRecord
  has_many :ruby_methods, dependent: :destroy

  def class_object?
    object_type == "class"
  end

  def module_object?
    object_type == "module"
  end
end
