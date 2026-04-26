# frozen_string_literal: true

require_relative "../ruby_downloader"
require_relative "../ruby_documentation_importer"

namespace :import do
  desc "import Ruby documentation for given version"
  task :ruby, [ :version ] => :environment do |t, args|
    args.with_defaults version: RubyRelease.latest.version

    release = if args.present?
      RubyRelease.version_for(args[:version])
    end

    if release.blank?
      puts "Could not find MRI release for version #{args.version}"
      exit 1
    end

    Searchkick.callbacks(:bulk) do
      ActiveRecord::Base.transaction do
        RubyObject.where(documentable: release).delete_all

        RubyDocumentationImporter.import release
      end
    end

    SitemapRefreshJob.perform_later
  end

  namespace :ruby do
    task all: :environment do
      RubyRelease.find_each do |version|
        Searchkick.callbacks(:bulk) do
          RubyDocumentationImporter.import version
        end
      end

      SitemapRefreshJob.perform_later
    end
  end
end
