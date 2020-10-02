# frozen_string_literal: true

require "test_helper"

class RubyVersionTest < ActiveSupport::TestCase
  test "#initialize" do
    assert_raises ArgumentError do
      RubyVersion.new("invalid-version")
    end
  end

  test "#minor_version" do
    version = RubyVersion.new("2.4.0")
    assert_equal version.minor_version, "2.4"
  end

  test "#prerelease?" do
    version = RubyVersion.new("2.7.0-preview3")
    assert_equal version.prerelease?, true

    version = RubyVersion.new("2.7.0")
    assert_equal version.prerelease?, false
  end

  test "#dev?" do
    version = RubyVersion.new("dev")
    assert_equal version.dev?, true

    version = RubyVersion.new("2.4.0")
    assert_equal version.dev?, false
  end
end
