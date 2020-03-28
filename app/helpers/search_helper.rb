# frozen_string_literal: true

module SearchHelper
  def method_anchor(method)
    # See https://github.com/ruby/rdoc/blob/c64210219ec6c0f447b4c66c2c3556cfe462993f/lib/rdoc/method_attr.rb#L294
    method_name = CGI.escape(method.name.gsub("-", "-2D")).tr("%", "-").sub(/^-/, "")

    "method-#{method.instance_method? ? "i" : "c"}-#{method_name}"
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
