# frozen_string_literal: true

require_relative "../ruby_downloader"
require_relative "../ruby_documentation_importer"

namespace :import do
  desc "import Ruby documentation for given version"
  task :ruby, [:version] => :environment do |t, args|
    args.with_defaults version: RubyConfig.default_ruby_version.version

    version = Gem::Version.new(args[:version])
    if version.segments.size > 2
      warn "Ruby API no longer allows importing an exact version of Ruby, instead just use `3.1`, `3.0` etc in the future. " \
        "See `config/ruby.yml` of the list of versions and the link to their ruby-src"
      version = version.segments[0..1].join(".")
    end

    release = RubyConfig.ruby_versions.find { |v| v.version == version }

    unless release.present?
      puts "Could not find MRI release for version #{args.version}"
      exit 1
    end

    RubyDocumentationImporter.import release
  end

  namespace :ruby do
    task all: :environment do
      RubyConfig.ruby_versions.each { |release| RubyDocumentationImporter.import release }
    end
  end
end
