class RubyGemVersion < ApplicationRecord
  validates :version, presence: true

  belongs_to :rubygem, class_name: "RubyGem"

  def slug
    "#{rubygem.name}-#{version}"
  end
end
