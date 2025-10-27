# frozen_string_literal: true

module ApplicationHelper
  GITHUB_REPO = "https://github.com/ruby/ruby/blob"

  def homepage?
    current_page?(root_path) || current_page?(versioned_root_path(version: Current.ruby_release.version))
  end

  # Map a method source file into a url to Github.com
  def github_url(ruby_doc, release:)
    # Not using URI.join, for a performance optimization. URI.join does A LOT of allocations.
    # We know that our source_location is safe, because we make it in the importer.
    # Inspiration: https://github.com/rack/rack/pull/1202
    %(#{GITHUB_REPO}/#{release.git_ref}/#{ruby_doc.source_file}#{"#L#{ruby_doc.source_line}" if ruby_doc.source_line.present?})
  end
end
