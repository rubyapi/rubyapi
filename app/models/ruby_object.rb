class RubyObject < ApplicationRecord
  CORE_CLASSES = {
    # Tier 1: The "Big 4" + Kernel - Most searched Ruby classes
    # Using much larger values because function_score adds these (not multiplies)
    "String" => 100.0,
    "Array" => 100.0,
    "Hash" => 100.0,
    "Integer" => 100.0,
    "Kernel" => 100.0,  # Fundamental Ruby module with puts, print, raise, etc.

    # Tier 2: Very common for method searches
    "Enumerable" => 75.0,
    "Time" => 75.0,
    "Regexp" => 75.0,
    "Range" => 75.0,
    "Object" => 75.0,  # Promoted - base class with important methods
    "Date" => 75.0,    # Common stdlib class for date handling
    "JSON" => 75.0,    # Common stdlib module for JSON parsing
    "BasicObject" => 50.0,
    "Symbol" => 50.0,
    "Float" => 50.0,
    "Numeric" => 50.0,

    # Tier 3: Used, but less frequently searched
    "IO" => 10.0,
    "Thread" => 10.0,
    "Struct" => 10.0,
    "Set" => 10.0,
    "Module" => 10.0,
    "Class" => 10.0,
    "Proc" => 10.0,
    "File" => 10.0,
    "Dir" => 10.0
  }.freeze
  
  has_many :ruby_methods, dependent: :destroy
  has_many :ruby_class_methods, -> { where(method_type: "class_method") }, class_name: "RubyMethod", inverse_of: :ruby_object
  has_many :ruby_instance_methods, -> { where(method_type: "instance_method") }, class_name: "RubyMethod", inverse_of: :ruby_object
  has_many :ruby_attributes, dependent: :destroy
  has_many :ruby_constants, dependent: :destroy

  belongs_to :superclass, class_name: "RubyObject", foreign_key: "superclass_constant", primary_key: :constant, optional: true
  belongs_to :documentable, polymorphic: true

  searchkick searchable: [ :name, :description, :constant, :constant_prefix ],
    word_start: [ :name, :constant, :constant_prefix ],
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
      type_boost: CORE_CLASSES[constant] ? 100.0 : 1.0,
      depth: depth,
      depth_boost: 1.0 / depth
    }
  end

  def included_modules
    return RubyObject.none if included_module_constants.blank?
    
    RubyObject.where(constant: included_module_constants)
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
