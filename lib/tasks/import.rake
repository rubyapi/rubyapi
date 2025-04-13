# frozen_string_literal: true

require_relative "../ruby_downloader"
require_relative "../ruby_documentation_importer"

namespace :import do
  desc "import Ruby documentation for given version"
  task :ruby, [:version] => :environment do |t, args|
    args.with_defaults version: RubyConfig.default_ruby_version.version

    release = if args.present?
      RubyConfig.ruby_versions.find { |v| v.version == args[:version] }
    else
      RubyConfig.default_ruby_version
    end

    if release.blank?
      puts "Could not find MRI release for version #{args.version}"
      exit 1
    end

    RubyDocumentationImporter.import release
  end

  namespace :ruby do
    task versions: :environment do
      versions = RubyConfig.versions.map do |v|  
        {
          version: v[:version].to_s,
          url: v[:url],
          sha256: v[:sha256] || "",
          default: v[:default] || false,
          eol: v[:eol] || false,
          prerelease: v[:prerelease] || false,
          git: v[:git] || {},
          signatures: v[:signatures] || false,
        }
      end

      RubyVersion.upsert_all(versions, unique_by: :version)
    end


    task all: :environment do
      RubyConfig.ruby_versions.each { |release| RubyDocumentationImporter.import release }
    end
  end
end
