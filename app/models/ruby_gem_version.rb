class RubyGemVersion < ApplicationRecord
  validates :version, presence: true

  belongs_to :ruby_gem

  def slug
    "#{rubygem.name}-#{version}"
  end
end
