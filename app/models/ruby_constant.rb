class RubyConstant < ApplicationRecord
  belongs_to :ruby_object

  validates :name, presence: true
  validates :constant, presence: true

  scope :ordered, -> { order(:name) }

  searchkick searchable: [:name, :description, :constant, :constant_prefix],
    word_start: [:name, :constant, :constant_prefix],
    word_middle: [:constant],
    filterable: [:documentable_type, :documentable_id]

  def search_data
    {
      name: name,
      description: description,
      constant: constant,
      constant_prefix: constant.downcase,
      documentable_type: ruby_object.documentable_type,
      documentable_id: ruby_object.documentable_id,
      documentable_name: ruby_object.documentable&.version,
      object_constant: ruby_object.constant,
      popularity_boost: RubyObject::CORE_CLASSES[ruby_object.constant] || 1.0,
      type_boost: 1.0,
      depth: ruby_object.depth,
      depth_boost: 1.0 / ruby_object.depth
    }
  end
end
