module SearchHelper
  def result_url(object_or_method)
    if object_or_method.is_a?(RubyMethod)
      object_url version: ruby_version, object: object_or_method.ruby_object, anchor: method_anchor(object_or_method)
    elsif object_or_method.is_a?(RubyObject)
      object_url version: ruby_version, object: object_or_method
    end
  end
end
