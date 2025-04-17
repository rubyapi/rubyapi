require "rdoc"

class GenerateRubyGemDocsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    @rubygem_version = RubyGemVersion.find(args[0])
    @rubygem_import = RubyGemImport.find_or_create_by(ruby_gem_version: @rubygem_version)

    process_rubygem!
  end

  private

  def process_rubygem!
    @rubygem_import.pending!

    @rdoc_options = RDoc::Options.load_options
    @rdoc = RDoc::RDoc.new

    @rdoc_options.tap do |r|
      r.generator = RubyAPIRDocGenerator
      r.files = Dir[RubyGemDownloader.download(@rubygem_version).download_path]
      r.template = ""
      r.quiet = true
      r.visibility = :private
      r.op_dir = Rails.root.join("tmp/rdoc")
      r.generator_options = [ @rubygem_version ]
    end

    @rdoc.document @rdoc_options

    @rubygem_import.completed!
  rescue StandardError => e
    @rubygem_import.update(error: e.message, status: :failed)
    raise e
  ensure
    @rubygem_import.save!
  end
end
