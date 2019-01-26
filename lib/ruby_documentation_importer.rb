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
  end

  def import
    @rdoc_options.tap do |r|
      r.generator = StudyRubyRDocGenerator
      r.files = Dir[path]
      r.template = ""
      r.quiet = true
      r.op_dir = Rails.root.join("tmp", "rdoc")
      r.generator_options = [version]
    end

    puts "Importing Ruby #{version} documentation"
    @rdoc.document @rdoc_options
  end
end
