class RubyGem < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :versions, class_name: "RubyGemVersion"
  has_one :version, -> { where("version = rubygems.latest_version") }, class_name: "RubyGemVersion", foreign_key: "rubygem_id"
end