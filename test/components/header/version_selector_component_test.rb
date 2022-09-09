# frozen_string_literal: true

require "test_helper"

class Header::VersionSelectorComponentTest < ViewComponent::TestCase
  def test_component_renders_current_ruby_version
    render_inline(Header::VersionSelectorComponent.new(current_version: "3.1", versions: []))

    assert_button "3.1"
  end

  def test_component_renders_ruby_versions
    ruby_versions = [
      RubyVersion.new("3.1"),
      RubyVersion.new("2.7")
    ]

    render_inline(Header::VersionSelectorComponent.new(current_version: "3.1", versions: ruby_versions))

    assert_link "3.1", href: "/3.1"
    assert_link "2.7", href: "/2.7"
  end
end
