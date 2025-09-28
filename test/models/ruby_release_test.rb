# frozen_string_literal: true

require "test_helper"

class RubyReleaseTest < ActiveSupport::TestCase
  test "invalid version" do
    version = RubyRelease.new(version: "invalid")
    assert_not version.valid?
    assert_includes version.errors[:version], "is not a valid semantic version"
  end

  test "prerelease version" do
    version = RubyRelease.new(version: "2.7.0-alpha", prerelease: true)
    assert version.prerelease?

    development_version = RubyRelease.new(version: "dev")
    assert development_version.dev?
  end

  test "ordered scope" do
    assert_equal ["3.4", "2.7", "dev"], RubyRelease.ordered.map(&:version)
  end
end
