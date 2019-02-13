require "rdoc"
require_relative "rubyapi_rdoc_generator"

class RubyDocumentationImpoter
  attr_reader :version, :path

  def self.import(version, path)
    importer = new(version, path)
    importer.import
    importer
  end

  def initialize(version, path)
    @version = version
    @path = path
    @rdoc = RDoc::RDoc.new
    @rdoc_options = @rdoc.load_options
    @spinner = TTY::Spinner.new ":spinner Importing Ruby #{version} documentation"
  end

  def import
    @spinner.auto_spin

    @rdoc_options.tap do |r|
      r.generator = StudyRubyRDocGenerator
      r.files = Dir[path]
      r.template = ""
      r.quiet = true
      r.op_dir = Rails.root.join("tmp", "rdoc")
      r.generator_options = [version]
    end

    @rdoc.document @rdoc_options
    @spinner.stop
    puts "Done."
  end
end
