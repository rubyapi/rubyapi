# frozen_string_literal: true

class RubyMethod < ApplicationRecord
  validates :name, presence: true

  belongs_to :ruby_object

  scope :class_methods, -> { where(method_type: "class_method") }
  scope :instance_methods, -> { where(method_type: "instance_method") }

  searchkick searchable: [ :name, :description, :constant ],
    word_start: [ :name ],
    word_middle: [ :constant ],
    filterable: [ :ruby_version ]

  def search_data
    {
      ruby_version: ruby_object&.ruby_version&.version,
      ruby_gem_version: ruby_object&.ruby_gem_version&.version,
      ruby_gem: ruby_object&.ruby_gem_version&.ruby_gem&.name,
      name: name,
      description: description,
      constant: constant
    }
  end

  def instance_method?
    method_type == "instance_method"
  end

  def class_method?
    method_type == "class_method"
  end

  def type_identifier
    if instance_method?
      "#"
    elsif class_method?
      "::"
    end
  end

  def is_alias?
    method_alias.present?
  end

  def source_file
    source_properties[1]
  end

  def source_line
    source_properties[2]
  end

  private

  def source_properties
    source_location.split(":")
  end
end
