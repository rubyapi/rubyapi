require "rdoc"

class GenerateRubyDocsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    @ruby_version = RubyVersion.find_by(version: args[0])
    @rdoc_options = RDoc::Options.load_options
    @rdoc = RDoc::RDoc.new

    @rdoc_options.tap do |r|
      r.generator = RubyAPIRDocGenerator
      r.files = Dir[RubyDownloader.download(@ruby_version).extracted_download_path]
      r.template = ""
      r.quiet = true
      r.visibility = :private
      r.op_dir = Rails.root.join("tmp/rdoc")
      r.generator_options = [ @ruby_version ]
    end

    @rdoc.document @rdoc_options
  end
end
