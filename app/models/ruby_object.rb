# frozen_string_literal: true

class RubyObject < ApplicationRecord
  CORE_RUBY_CLASS_BOOST = {
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
  has_many :ruby_constants, dependent: :destroy
  has_many :ruby_attributes, dependent: :destroy

  belongs_to :ruby_version, dependent: :destroy

  validates :name, :path, presence: true
  validates :object_type, inclusion: { in: %w[class_object module_object] }

  searchkick searchable: [:name, :description],
    word_start: [:name],
    word_middle: [:constant],
    filterable: [:ruby_version]

  def search_data
    {
      ruby_version: ruby_version.version,
      path: path,
      name: name,
      description: description,
      constant: constant
    }
  end

  def class_object?
    object_type == "class_object"
  end

  def module_object?
    object_type == "module_object"
  end
end
