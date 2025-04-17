class RubyGemVersion < ApplicationRecord
  validates :version, presence: true

  belongs_to :ruby_gem
  has_one :ruby_gem_import, dependent: :destroy

  def slug
    "#{ruby_gem.name}-#{version}"
  end
end
