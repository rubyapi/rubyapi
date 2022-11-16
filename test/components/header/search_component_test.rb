# frozen_string_literal: true

require "test_helper"

class Header::SearchComponentTest < ViewComponent::TestCase
  def test_component_renders_search_form_for_version
    Current.ruby_version = FactoryBot.build(:ruby_version, version: "2.7")

    render_inline(Header::SearchComponent.new)

    assert_selector "form[action='/2.7/o/s']"
  end

  def test_component_renders_autocomplete_attributes
    Current.ruby_version = FactoryBot.build(:ruby_version, version: "2.7")

    render_inline(Header::SearchComponent.new)

    assert_selector "div[data-search-version='2.7']"
    assert_selector "div[data-search-url='/2.7/a']"
  end
end
