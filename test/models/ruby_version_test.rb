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
    assert RubyVersion.new("2.7.0-preview3").prerelease?
    refute RubyVersion.new("2.7.0").prerelease?
  end

  test "#dev?" do
    assert RubyVersion.new("dev").dev?
    refute RubyVersion.new("2.4.0").dev?
  end

  test "eol?" do
    refute RubyVersion.new("3.1", eol: false).eol?
    assert RubyVersion.new("2.4.0", eol: true).eol?
  end

  test "default?" do
    refute RubyVersion.new("3.1", default: false).default?
    assert RubyVersion.new("3.1", default: true).default?
  end
end
