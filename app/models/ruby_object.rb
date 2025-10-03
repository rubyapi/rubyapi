class RubyObject < ApplicationRecord
  CORE_CLASSES = {
    "String" => 1.5,
    "Integer" => 1.5,
    "Float" => 1.5,
    "Symbol" => 1.5,
    "Array" => 1.3,
    "Enumerable" => 1.3,
    "Hash" => 1.3,
    "Time" => 1.3,
    "Regex" => 1.3,
    "Numeric" => 1.3,
    "StringIO" => 1.3,
    "Object" => 1.3,
    "Struct" => 1.3,
    "Thread" => 1.1,
    "Signal" => 1.1,
    "Range" => 1.1,
    "IO" => 1.1
  }.freeze
  
  has_many :ruby_methods, dependent: :destroy
  has_many :ruby_class_methods, -> { where(method_type: "class") }, class_name: "RubyMethod", inverse_of: :ruby_object
  has_many :ruby_instance_methods, -> { where(method_type: "instance") }, class_name: "RubyMethod", inverse_of: :ruby_object
  has_many :ruby_attributes, dependent: :destroy
  has_many :ruby_constants, dependent: :destroy

  belongs_to :superclass, class_name: "RubyObject", foreign_key: "superclass_constant", primary_key: "constant", optional: true
  has_many :included_modules, ->(obj) { where(constant: obj.included_module_constants) }, class_name: "RubyObject"
  belongs_to :documentable, polymorphic: true

  searchkick searchable: [ :name, :description ],
    word_start: [ :name ],
    word_middle: [ :constant ],
    filterable: [ :ruby_version ]

  def search_data
    {
      path: path,
      name: name,
      description: description,
      constant: constant
    }
  end

  def class_object?
    object_type == "class"
  end

  def module_object?
    object_type == "module"
  end
end
