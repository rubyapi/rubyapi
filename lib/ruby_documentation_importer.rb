# frozen_string_literal: true

require "rdoc"
require_relative "rubyapi_rdoc_generator"

class RubyDocumentationImporter
  attr_reader :release

  def self.import(release)
    new(release).import
  end

  def initialize(release)
    @release = release
    @rdoc = RDoc::RDoc.new
    @rdoc_options = @rdoc.load_options
    @spinner = TTY::Spinner.new ":spinner Importing Ruby #{release.version} documentation"
  end

  def import
    path = fetch_ruby_src_for_release(release).extracted_download_path

    @spinner.auto_spin

    @rdoc_options.tap do |r|
      r.generator = RubyAPIRDocGenerator
      r.files = Dir[path]
      r.template = ""
      r.quiet = true
      r.op_dir = Rails.root.join("tmp", "rdoc")
      r.generator_options = [release]
    end

    @rdoc.document @rdoc_options

    @spinner.stop
    puts "Done."
  end

  private

  def fetch_ruby_src_for_release(release)
    RubyDownloader.download(release)
  end
end
