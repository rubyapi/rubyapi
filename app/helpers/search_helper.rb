# frozen_string_literal: true

module SearchHelper
  @@class_method_anchors = Concurrent::Map.new
  @@instance_method_anchors = Concurrent::Map.new

  def escape_method_name(method_name)
    # See https://github.com/ruby/rdoc/blob/c64210219ec6c0f447b4c66c2c3556cfe462993f/lib/rdoc/method_attr.rb#L294
    CGI.escape(method_name.gsub("-", "-2D")).tr("%", "-").sub(/^-/, "").freeze
  end

  def method_anchor(method)
    collection = method.instance_method? ? @@instance_method_anchors : @@class_method_anchors
    collection.compute_if_absent(method.name) do
      "method-#{method.instance_method? ? "i" : "c"}-#{escape_method_name(method.name)}"
    end
  end

  def result_url(result, version:)
    routes = Rails.application.routes.url_helpers
    if result.is_a?(RubyMethod)
      routes.object_path version: version, object: result.object_path, anchor: method_anchor(result)
    elsif result.is_a?(RubyObject)
      routes.object_path version: version, object: result.path
    end
  end
end
