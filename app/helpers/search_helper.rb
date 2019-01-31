module SearchHelper
  def result_url(object_or_method)
    object = object_or_method.is_a?(RubyMethod) ? object_or_method.ruby_object : object_or_method

    object_url version: ruby_version, object: object, anchor: object_or_method.try(:anchor)
 end
end
