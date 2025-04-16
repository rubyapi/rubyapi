class RubyGem < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :latest_version, presence: true
  
  has_many :ruby_gem_versions, dependent: :destroy

  def latest
    ruby_gem_versions.find_by(version: latest_version)
  end
end