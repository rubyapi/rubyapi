module SearchHelper
  def method_anchor(method)
    # See https://github.com/ruby/rdoc/blob/c64210219ec6c0f447b4c66c2c3556cfe462993f/lib/rdoc/method_attr.rb#L294
    method_name = CGI.escape(method.name.gsub("-", "-2D")).tr("%", "-").sub(/^-/, "")

    "method-#{method.instance_method? ? "i" : "c"}-#{method_name}"
  end

  def result_url(object_or_method)
    routes = Rails.application.routes.url_helpers
    if object_or_method.is_a?(RubyMethod)
      routes.object_path version: object_or_method.version, object: object_or_method.ruby_object, anchor: method_anchor(object_or_method)
    elsif object_or_method.is_a?(RubyObject)
      routes.object_path version: object_or_method.version, object: object_or_method
    end
  end
end
