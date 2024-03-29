# frozen_string_literal: true

class ThemeConfig < ApplicationConfig
  attr_config :themes
  # coerce_types themes: {type: nil, array: true}

  on_load :ensure_default_theme

  def all
    @themes ||= build_themes
  end

  def default_theme
    @default_theme ||= all.find(&:default?)
  end

  def theme_for(name)
    all.find { |theme| theme.name == name }
  end

  private

  def build_themes
    themes.map do |t|
      Theme.new(
        name: t[:name],
        icon: t[:icon],
        meta: t[:meta],
        dynamic: t[:dynamic] || false,
        default: t[:default] || false
      )
    end
  end

  def ensure_default_theme
    raise "Missing default Ruby Version, see ruby.yml" unless default_theme.present?
  end
end
