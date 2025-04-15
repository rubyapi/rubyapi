# frozen_string_literal: true

require "test_helper"

class Header::VersionSelectorComponentTest < ViewComponent::TestCase
  def test_component_renders_current_ruby_version
    latest = ruby_version(:latest)
    Current.ruby_version = latest

    render_inline(Header::VersionSelectorComponent.new(versions: []))

    assert_button latest.version
  end

  def test_component_renders_ruby_versions
    latest = ruby_version(:latest)
    legacy = ruby_version(:legacy)

    ruby_versions = [
      latest,
      legacy
    ]

    render_inline(Header::VersionSelectorComponent.new(versions: ruby_versions))

    assert_link "#{latest.version}", href: "/#{latest.version}"
    assert_link "#{legacy.version}", href: "/#{legacy.version}"
  end
end
