# frozen_string_literal: true

require "rdoc"
require_relative "rubyapi_rdoc_generator"
require_relative "import_ui"

class RubyDocumentationImporter
  attr_reader :release

  def self.import(...)
    new(...).import
  end

  def initialize(release)
    raise ArgumentError, "#{release.inspect} is not a RubyRelease" unless release.is_a?(RubyRelease)

    @release = release

    ImportUI.reset
  end

  def import
    path = fetch_ruby_src_for_release(release).extracted_download_path

    ImportUI.start ":spinner Importing Ruby #{release.version} documentation"

    # Run rdoc from the release directory to load .rdoc_options
    # and resolve `:include:` and `rdoc-ref:` directives.
    Dir.chdir(path) do
      @rdoc_options = RDoc::Options.load_options.tap do |options|
        options.generator = RubyAPIRDocGenerator
        options.generator_options = [ release ]
        options.root = path.to_s
        options.files = [ "." ]
        options.op_dir = Rails.root.join("tmp/rdoc").to_s
        options.visibility = :private
        options.verbosity = 0
        options.template = ""

        # Older releases:
        options.page_dir ||= "doc" # missing page_dir in .rdoc_options
        options.files << "doc/date" if File.directory?("doc/date") # missing Date pages in doc/.document.
      end

      @rdoc = RDoc::RDoc.new
      @rdoc.document @rdoc_options
    end

    ImportUI.finish
  end

  private

  def fetch_ruby_src_for_release(release)
    RubyDownloader.download(release)
  end
end
