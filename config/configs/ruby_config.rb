# frozen_string_literal: true

class RubyConfig < ApplicationConfig
  attr_config :versions
  coerce_types versions: {type: nil, array: true}

  on_load :ensure_default_version

  private

  def ensure_default_version
    raise "Missing default Ruby Version, see ruby.yml" unless versions.pluck(&:default)
  end
end
