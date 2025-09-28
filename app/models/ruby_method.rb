class RubyMethod < ApplicationRecord
  validates :name, presence: true

  belongs_to :ruby_object

  scope :class_methods, -> { where(method_type: 'class') }
  scope :instance_methods, -> { where(method_type: 'instance') }

  def instance_method?
    method_type == 'instance'
  end

  def class_method?
    method_type == 'class'
  end

  def type_identifier
    instance_method? ? '#' : '.'
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
