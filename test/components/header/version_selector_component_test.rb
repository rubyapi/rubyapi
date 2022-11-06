# frozen_string_literal: true

require "test_helper"

class Header::VersionSelectorComponentTest < ViewComponent::TestCase
  def test_component_renders_current_ruby_version
    render_inline(Header::VersionSelectorComponent.new(versions: []))

    assert_button "3.1"
  end

  def test_component_renders_ruby_versions
    ruby_versions = [
      FactoryBot.build(:ruby_version, version: "3.0"),
      FactoryBot.build(:ruby_version, version: "2.7")
    ]

    render_inline(Header::VersionSelectorComponent.new(versions: ruby_versions))

    assert_link "3.0", href: "/3.0"
    assert_link "2.7", href: "/2.7"
  end
end
