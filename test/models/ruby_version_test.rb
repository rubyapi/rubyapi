# frozen_string_literal: true

require "test_helper"

class RubyVersionTest < ActiveSupport::TestCase
  test "invalid version" do
    version = RubyVersion.new(version: "invalid")
    assert_not version.valid?
    assert_includes version.errors[:version], "is not a valid semantic version"
  end

  test "prerelease version" do
    version = RubyVersion.new(version: "2.7.0-alpha", prerelease: true)
    assert version.prerelease?

    development_version = RubyVersion.new(version: "dev")
    assert development_version.dev?
  end
end
