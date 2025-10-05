class RubyObject < ApplicationRecord
  CORE_CLASSES = {
    # Tier 1 (1.5x): The "Big 4" - Most searched Ruby classes
    "String" => 1.5,
    "Array" => 1.5,
    "Hash" => 1.5,
    "Integer" => 1.5,

    # Tier 2 (1.3x): Very common, but slightly less frequent
    "Enumerable" => 1.3,
    "Time" => 1.3,
    "Regexp" => 1.3,
    "Range" => 1.3,
    "File" => 1.3,
    "Dir" => 1.3,
    "Symbol" => 1.3,
    "Float" => 1.3,
    "Numeric" => 1.3,
    "Object" => 1.3,

    # Tier 3 (1.1x): Used, but less frequently searched
    "IO" => 1.1,
    "Thread" => 1.1,
    "Struct" => 1.1,
    "Set" => 1.1,
    "Module" => 1.1,
    "Class" => 1.1,
    "Proc" => 1.1
  }.freeze
  
  has_many :ruby_methods, dependent: :destroy
  has_many :ruby_class_methods, -> { where(method_type: "class_method") }, class_name: "RubyMethod", inverse_of: :ruby_object
  has_many :ruby_instance_methods, -> { where(method_type: "instance_method") }, class_name: "RubyMethod", inverse_of: :ruby_object
  has_many :ruby_attributes, dependent: :destroy
  has_many :ruby_constants, dependent: :destroy

  belongs_to :superclass, class_name: "RubyObject", foreign_key: "superclass_constant", primary_key: :constant, optional: true
  has_many :included_modules, ->(obj) { where(constant: obj.included_module_constants) }, foreign_key: :id, class_name: "RubyObject"
  belongs_to :documentable, polymorphic: true

  searchkick searchable: [ :name, :description, :constant ],
    word_start: [ :name, :constant ],
    word_middle: [ :constant ],
    filterable: [ :documentable_type, :documentable_id ]

  def search_data
    {
      path: path,
      name: name,
      description: description,
      constant: constant,
      constant_prefix: constant.downcase, # For better prefix matching
      documentable_type: documentable_type,
      documentable_id: documentable_id,
      documentable_name: documentable&.version,
      object_type: object_type,
      popularity_boost: CORE_CLASSES[constant] || 1.0,
      type_boost: CORE_CLASSES[constant] ? 2.0 : 1.1,
      depth: depth
    }
  end

  def class_object?
    object_type == "class"
  end

  def module_object?
    object_type == "module"
  end

  def depth
    constant.split("::").length
  end
end
