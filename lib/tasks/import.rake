# frozen_string_literal: true

require_relative "../ruby_downloader"
require_relative "../ruby_documentation_importer"

namespace :import do
  desc "import Ruby documentation for given version"
  task :ruby, [:version] => :environment do |t, args|
    args.with_defaults version: RubyRelease.default.version

    release = if args.present?
      RubyRelease.version_for(args[:version])
    end

    if release.blank?
      puts "Could not find MRI release for version #{args.version}"
      exit 1
    end

    RubyDocumentationImporter.import release
  end

  namespace :ruby do
    task all: :environment do
      RubyRelease.each do |version|
        RubyDocumentationImporter.import version
      end
    end
  end
end
