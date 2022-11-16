# frozen_string_literal: true

class Header::ThemeSelectorComponent < ViewComponent::Base
  def initialize(themes: ThemeConfig.all, current_theme: Current.theme)
    @current_theme = current_theme
    @themes = themes
  end
end
