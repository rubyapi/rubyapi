# frozen_string_literal: true

require "test_helper"

class HeaderComponentTest < ViewComponent::TestCase
  def test_component_renders_search_bar
    render_inline(HeaderComponent.new(show_search: true))

    assert_selector "input#search"
  end

  def test_component_renders_fixed_navbar
    render_inline(HeaderComponent.new(fixed_nav: true))

    assert_selector "header.fixed"
  end
end
