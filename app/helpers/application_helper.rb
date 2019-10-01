# frozen_string_literal: true

module ApplicationHelper
  GITHUB_REPO = "https://github.com/ruby/ruby/blob/"
  MASTER = "master"

  def master?
    ruby_version == MASTER
  end

  def homepage?
    current_page?(root_path) || current_page?(versioned_root_path(version: ruby_version))
  end

  # Map a method source file into a url to Github.com
  def github_url(ruby_doc)
    version, file, line = ruby_doc.source_location.split(":")

    if version == MASTER
      path = File.join version, file
    else
      github_version = version.tr(".", "_")
      path = File.join "v#{github_version}", file
    end

    URI.join(GITHUB_REPO, path, "#L#{line}").to_s
  end
end
