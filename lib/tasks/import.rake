# frozen_string_literal: true

require_relative "../ruby_downloader"
require_relative "../ruby_documentation_importer"

namespace :import do
  desc "import Ruby documentation for given version"
  task :ruby, [:version] => :environment do |t, args|
    args.with_defaults version: Rails.configuration.default_ruby_version

    release = RubyReleases::ReleaseList.fetch.find { |r| r.version.to_s == args.version }

    unless release
      puts "Could not find MRI release for version #{args.version}"
      exit 1
    end

    RubyDocumentationImporter.import release
  end

  namespace :ruby do
    task all: :environment do
      releases = RubyReleases::ReleaseList.fetch

      Rails.configuration.ruby_versions.each do |v|
        release = releases.select { |r| r.minor_version == v }.max_by(&:version)
        RubyDocumentationImporter.import release
      end
    end
  end
end
