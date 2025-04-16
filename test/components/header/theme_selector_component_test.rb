# frozen_string_literal: true

require "test_helper"

class Header::ThemeSelectorComponentTest < ViewComponent::TestCase
  def setup
    @dark_theme = Theme.new(name: "dark", icon: "<i>Dark Theme Icon</i>")
    @light_theme = Theme.new(name: "light", icon: "<i>Light Theme Icon</i>")
  end

  def test_component_renders_current_theme_icon
    render_inline(Header::ThemeSelectorComponent.new(themes: [ @dark_theme ], current_theme: @dark_theme))
    assert_selector("#theme-icon-container i", text: "Dark Theme Icon")
  end

  def test_component_renders_theme_list
    render_inline(Header::ThemeSelectorComponent.new(themes: [ @dark_theme, @light_theme ], current_theme: @dark_theme))
    assert_selector('button[value="dark"]', text: "Dark")
    assert_selector('button[value="light"]', text: "Light")
  end

  def test_component_renders_active_theme
    render_inline(Header::ThemeSelectorComponent.new(themes: [ @dark_theme, @light_theme ], current_theme: @dark_theme))
    assert_selector("button.text-blue-800.bg-blue-200", text: "Dark")
    assert_selector("button:not(.text-blue-800.bg-blue-200)", text: "Light")
  end
end
