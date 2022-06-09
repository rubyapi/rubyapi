# frozen_string_literal: true

class RubyConfig < ApplicationConfig
  attr_config :versions
  coerce_types versions: {type: nil, array: true}

  on_load :ensure_default_version

  def ruby_versions
    @ruby_versions ||= build_ruby_versions
  end

  def default_ruby_version
    @default_ruby_version ||= ruby_versions.find(&:default?)
  end

  def active_ruby_versions
    @active_ruby_versions ||= ruby_versions.reject(&:eol?)
  end

  def eol_ruby_versions
    @eol_ruby_verisons ||= ruby_versions.select(&:eol?)
  end

  private

  def ensure_default_version
    raise "Missing default Ruby Version, see ruby.yml" unless ruby_versions.any?(&:default?)
  end

  def build_ruby_versions
    versions.map do |v|
      raise "Missing Ruby Version" unless v[:version].present?

      RubyVersion.new(
        v[:version].to_s,
        default: v[:default],
        eol: v[:eol]
      )
    end
  end
end
