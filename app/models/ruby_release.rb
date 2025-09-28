# frozen_string_literal: true

class RubyRelease < ApplicationRecord
  validates :version, presence: true
  validate :check_version

  scope :latest, -> { where(default: true).first }
  scope :ordered, -> { order(Arel.sql("version_key IS NULL, version_key DESC, version DESC")) }

  def self.version_for(version)
    RubyRelease.find_by(version: version)
  end

  def self.syndicate!
    RubyRelease.upsert_all(RubyConfig.ruby_releases, unique_by: :version)
  end

  def prerelease?
    dev? || prerelease
  end

  def git_ref
    git_tag.presence || git_branch
  end

  def dev?
    version == "dev"
  end

  private

  def check_version
    return if version == "dev"

    Gem::Version.new(version)
  rescue ArgumentError
    errors.add(:version, "is not a valid semantic version")
  end
end
