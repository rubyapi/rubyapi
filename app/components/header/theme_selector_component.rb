# frozen_string_literal: true

class Header::ThemeSelectorComponent < ViewComponent::Base
  def initialize
    @themes = ThemeConfig.all
  end
end
