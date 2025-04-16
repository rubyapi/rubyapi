# frozen_string_literal: true

module SearchHelper
  def escape_method_name(method_name)
    # See https://github.com/ruby/rdoc/blob/c64210219ec6c0f447b4c66c2c3556cfe462993f/lib/rdoc/method_attr.rb#L294
    (@escaped_method_names ||= {})[method_name] ||= CGI.escape(method_name.gsub("-", "-2D")).tr("%", "-").sub(/^-/, "")
  end

  def method_anchor(method)
    "method-#{method.instance_method? ? "i" : "c"}-#{escape_method_name(method.name)}"
  end

  def constant_anchor(constant)
    constant.name
  end

  def result_url(result, ruby_version:)
    routes = Rails.application.routes.url_helpers
    if result.is_a?(RubyMethod)
      routes.object_path version: ruby_version.version, object: result.ruby_object.path, anchor: method_anchor(result)
    elsif result.is_a?(RubyObject)
      routes.object_path version: ruby_version.version, object: result.path, anchor: nil
    elsif result.is_a?(RubyConstant)
      routes.object_path version: ruby_version.version, object: result.ruby_object.path, anchor: constant_anchor(result)
    end
  end
end
