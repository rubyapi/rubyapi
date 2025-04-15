# frozen_string_literal: true

class RubyConstant < ApplicationRecord
  belongs_to :ruby_object

  validates :name, presence: true

  searchkick searchable: [:name, :description, :constant],
    word_start: [:name],
    word_middle: [:constant],
    filterable: [:ruby_version]

  def search_data
    {
      ruby_version: ruby_object.ruby_version.version,
      name: name,
      description: description,
      constant: constant,
    }
  end
end