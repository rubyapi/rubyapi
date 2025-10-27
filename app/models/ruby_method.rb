class RubyMethod < ApplicationRecord
  validates :name, presence: true

  belongs_to :ruby_object

  scope :class_methods, -> { where(method_type: "class") }
  scope :instance_methods, -> { where(method_type: "instance") }

  scope :ordered, -> { order(:name) }

  searchkick searchable: [ :name, :description, :constant, :constant_prefix ],
    word_start: [ :name, :constant, :constant_prefix ],
    word_middle: [ :constant ],
    filterable: [ :documentable_type, :documentable_id ]

  validates :method_type, inclusion: { in: %w[instance class] }

  def search_data
    {
      name: name,
      description: description,
      constant: constant,
      constant_prefix: constant.downcase,
      documentable_type: ruby_object.documentable_type,
      documentable_id: ruby_object.documentable_id,
      documentable_name: ruby_object.documentable&.version,
      method_type: method_type,
      object_constant: ruby_object.constant,
      popularity_boost: RubyObject::CORE_CLASSES[ruby_object.constant] || 1.0,
      type_boost: 1.0,
      depth: ruby_object.depth,
      depth_boost: 1.0 / ruby_object.depth
    }
  end

  def instance_method?
    method_type == "instance"
  end

  def class_method?
    method_type == "class"
  end

  def type_identifier
    instance_method? ? "#" : "."
  end

  def is_alias?
    method_alias.present?
  end

  def source_file
    source_properties.first
  end

  def source_line
    source_properties.second.to_i
  end

  private

  def source_properties
    source_location.split(":")
  end
end
