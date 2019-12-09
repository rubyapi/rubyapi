require_relative "../ruby_downloader"
require_relative "../ruby_documentation_importer"

namespace :import do
  desc "import Ruby documentation for given version"
  task :ruby, [:version] => :environment do |t, args|
    args.with_defaults version: Rails.configuration.default_ruby_version

    downloader = RubyDownloader.download(args.version)
    RubyDocumentationImpoter.import(args.version, downloader.extracted_download_path)
  end

  namespace :ruby do
    task all: :environment do
      ruby_versions = Hash.new { |h, k| h[k] = [] }

      RubyReleases::ReleaseList.fetch.each do |r|
        minor_version = r.version.segments[0..1].join(".")
        ruby_versions[minor_version] << r.version.to_s
      end

      versions = Rails.configuration.ruby_versions.map { |v| ruby_versions[v].max }.compact

      versions.each do |v|
        downloader = RubyDownloader.download(v)
        RubyDocumentationImpoter.import(v, downloader.extracted_download_path)
      end
    end
  end
end
