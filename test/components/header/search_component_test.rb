# frozen_string_literal: true

require "test_helper"

class Header::SearchComponentTest < ViewComponent::TestCase
  def test_component_renders_autocomplete_attributes
    latest = ruby_version(:latest)
    Current.ruby_version = latest

    render_inline(Header::SearchComponent.new)

    assert_selector "div[data-search-version='#{latest.version}']"
    assert_selector "div[data-search-url='/#{latest.version}/a']"
  end
end
