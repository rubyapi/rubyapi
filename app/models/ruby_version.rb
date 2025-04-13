# frozen_string_literal: true

class RubyVersion < ApplicationRecord
  validates :version, presence: true
  validate :check_version

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
