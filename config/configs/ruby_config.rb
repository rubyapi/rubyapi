# frozen_string_literal: true

class RubyConfig < ApplicationConfig
  attr_config :versions
  coerce_types versions: {type: nil, array: true}

  on_load :ensure_default_version

  def ruby_releases
    @ruby_releases ||= build_ruby_releases
  end

  def default_ruby_version
    @default_ruby_version ||= ruby_releases.find { it[:default] }
  end

  private

  def ensure_default_version
    raise "Missing default Ruby Version, see ruby.yml" unless ruby_releases.any? { it[:default] }
  end

  def build_ruby_releases
    versions.map do |v|
      raise "Missing Ruby Version" unless v[:version].present?

      {
        version: v[:version].to_s,
        url: v[:url],
        sha256: v[:sha256] || "",
        default: v[:default] || false,
        eol: v[:eol] || false,
        prerelease: v[:prerelease] || false,
        git_branch: v[:git][:branch] || "",
        git_tag: v[:git][:tag] || "",
        signatures: v[:signatures] || false,
      }
    end
  end
end
