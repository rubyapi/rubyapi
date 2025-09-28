# frozen_string_literal: true

require "test_helper"

class Header::SearchComponentTest < ViewComponent::TestCase
  test "render search form for version" do
    render_preview(:with_version, params: { release: ruby_releases(:latest) })

    assert_selector "form[action='/3.4/o/s']"
  end

  test "render autocomplete attributes" do
    render_preview(:with_version, params: { release: ruby_releases(:latest) })

    assert_selector "div[data-search-version='3.4']"
    assert_selector "div[data-search-url='/3.4/a']"
  end
end
