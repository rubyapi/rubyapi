# frozen_string_literal: true

namespace :import do
  desc "import Ruby documentation for given version"
  task :ruby, [ :version ] => :environment do |t, args|
    release = args.version.present? ? RubyVersion.find_by(version: args.version) : RubyVersion.default

    if release.blank?
      puts "Could not find MRI release for version #{args.version}"
      exit 1
    end

    ActiveRecord::Base.transaction do
      release.ruby_objects.delete_all
      GenerateRubyDocsJob.perform_now(release.version)
    end

    puts "Successfully imported Ruby documentation for version #{release.version}"
  end

  task rubygems: :environment do
    CatalogueRubygemsJob.perform_later
    puts "RubyGems catalogue import started"
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
          git_tag: v[:git][:tag] || "",
          git_branch: v[:git][:branch] || "",
          signatures: v[:signatures] || false
        }
      end

      RubyVersion.upsert_all(versions, unique_by: :version)
      puts "#{versions.size} Ruby versions imported"
    end


    task all: :environment do
      RubyVersion.all.each { |release| RubyDocumentationImporter.import release }
    end
  end
end
