# frozen_string_literal: true

module ApplicationHelper
  GITHUB_REPO = "https://github.com/ruby/ruby/blob"
  DEV = "dev"

  def dev?
    ruby_version == DEV
  end

  def homepage?
    return(@is_homepage) if defined?(@is_homepage)
    @is_homepage = current_page?(root_path) || current_page?(versioned_root_path(version: ruby_version))
  end

  # Map a method source file into a url to Github.com
  def github_url(ruby_doc)
    version, file, line = ruby_doc.source_location.split(":")

    if version == DEV
      # Not using URI.join, for a performance optimization. URI.join does A LOT of allocations.
      # We know that our source_location is safe, because we make it in the importer.
      # Inspiration: https://github.com/rack/rack/pull/1202
      %(#{GITHUB_REPO}/master/#{file}#{"#L#{line}" if line})
    else
      %(#{GITHUB_REPO}/v#{version.tr(".", "_")}/#{file}#{"#L#{line}" if line})
    end
  end

  def object_link(class_name)
    link_to object_path(object: class_name.underscore, version: ruby_version), class: "inline-block" do
      content_tag(:code, class_name)
    end
  end
end
