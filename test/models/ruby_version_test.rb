# frozen_string_literal: true

require "test_helper"

class RubyVersionTest < ActiveSupport::TestCase
  test "invalid version" do
    assert_raises(ArgumentError) do
      RubyVersion.new(
        version: "abc",
        url: "https://example.com",
        sha256: SecureRandom.hex(32)
      )
    end

    assert_raises(ArgumentError) do
      RubyVersion.new(
        version: "",
        url: "https://example.com",
        sha256: SecureRandom.hex(32)
      )
    end
  end

  test "eol verison" do
    ruby_version = FactoryBot.build(:ruby_version, eol: true)
    assert ruby_version.eol?
  end

  test "dev version" do
    ruby_version = FactoryBot.build(:ruby_version, version: "dev")
    assert ruby_version.dev?
  end

  test "type signatures" do
    ruby_version = FactoryBot.build(:ruby_version, version: "3.0")
    assert ruby_version.has_type_signatures?

    ruby_version = FactoryBot.build(:ruby_version, version: "2.7")
    refute ruby_version.has_type_signatures?
  end

  test "prerelease version" do
    ruby_version = FactoryBot.build(:ruby_version, prerelease: true)
    assert ruby_version.prerelease?

    ruby_version = FactoryBot.build(:ruby_version, version: "dev")
    assert ruby_version.prerelease?
  end

  test "git ref" do
    ruby_version = FactoryBot.build(:ruby_version, git: {branch: "master"})
    assert_equal "master", ruby_version.git_ref

    ruby_version = FactoryBot.build(:ruby_version, git: {tag: "v1.0"})
    assert_equal "v1.0", ruby_version.git_ref
  end

  test "git branch" do
    ruby_version = FactoryBot.build(:ruby_version, git: {branch: "master"})
    assert_equal "master", ruby_version.git_branch
  end

  test "git tag" do
    ruby_version = FactoryBot.build(:ruby_version, git: {tag: "v1.0"})
    assert_equal "v1.0", ruby_version.git_tag
  end

  test "to string" do
    ruby_version = FactoryBot.build(:ruby_version, version: "3.1")
    assert_equal "3.1", ruby_version.to_s
  end
end
