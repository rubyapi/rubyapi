# frozen_string_literal: true

require "trenni/sanitize"
require_relative "import_ui"

class RubyDescriptionCleaner < Trenni::Sanitize::Filter
  def self.clean(version, object_constant, description)
    # Most of this method is copy/pasted from Trenni::Sanitize::Filter.parse
    # https://github.com/ioquatix/trenni-sanitize/blob/c8e08d2717b98a2268da89f8196fdb1eb93725bf/lib/trenni/sanitize/filter.rb#L40

    description = description.gsub(/(<a.*&para;<\/a>)/, "")
      .gsub(/(<a.*&uarr;<\/a>)/, "")
      .gsub("<pre class=\"ruby\">", "<div class=\"ruby\" data-controller=\"code-example\" data-target=\"code-example.block\" data-code-example-version=\"#{version}\"></div><pre class=\"ruby\">")
      .gsub(/<a.*?href=""\w+"".*?>(.+?)<\/a>/, "\\1")

    input = Trenni::Buffer(description)
    output = Trenni::MarkupString.new.force_encoding(input.encoding)
    entities = Trenni::Entities::HTML5

    delegate = new(output, entities)
    delegate.version = version
    delegate.object_constant = object_constant

    delegate.parse!(input)

    delegate.output
  rescue Trenni::ParseError
    ImportUI.warn "#{object_constant} contains unparsable HTML"
    description
  end

  attr_accessor :version, :object_constant

  def filter(node)
    if node.name == "a" && (url = node.tag.attributes["href"])
      uri = URI(url)
      if uri.host.nil? && uri.path.present?
        # Only edit relative paths, but skip anchor-only paths.
        node.tag.attributes["href"] = PathCleaner.clean(uri, constant: object_constant, version: version)
      end
    end

    node.accept!
  rescue URI::InvalidURIError
    ImportUI.warn "#{object_constant} contains invalid href: #{url}"
    # Not a valid URL, so get rid of the <a> and just return the content.
    # EG: '<a href=":ssl">options</a>' becomes 'options'
    node.skip!(TAG)
  end
end
