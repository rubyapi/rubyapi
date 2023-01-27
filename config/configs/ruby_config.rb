# frozen_string_literal: true

class RubyConfig < ApplicationConfig
  attr_config :versions
  coerce_types versions: {type: nil, array: true}

  on_load :ensure_default_version

  def version_for(version)
    ruby_versions.find { |v| v.version == version }
  end

  def ruby_versions
    @ruby_versions ||= build_ruby_versions
  end

  def default_ruby_version
    @default_ruby_version ||= ruby_versions.find(&:default?)
  end

  private

  def ensure_default_version
    raise "Missing default Ruby Version, see ruby.yml" unless ruby_versions.any?(&:default?)
  end

  def build_ruby_versions
    versions.map do |v|
      raise "Missing Ruby Version" unless v[:version].present?

      RubyVersion.new(
        version: v[:version].to_s,
        url: v[:url],
        sha256: v[:sha256] || "",
        default: v[:default] || false,
        eol: v[:eol] || false,
        prerelease: v[:prerelease] || false,
        git: v[:git] || {}
      )
    end
  end
end
