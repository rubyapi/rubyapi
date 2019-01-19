require_relative '../ruby_downloader'
require_relative '../ruby_documentation_importer'

namespace :import do
  desc "import Ruby documentation for given version"
  task :ruby, [:version] => :environment do |t, args|
    args.with_defaults version: Rails.configuration.default_ruby_version

    RubyMethod.where(version: args.version).delete_all
    RubyObject.where(version: args.version).delete_all

    downloader = RubyDownloader.download(args.version)
    RubyDocumentationImpoter.import(args.version, downloader.extracted_download_path)
  end
end
