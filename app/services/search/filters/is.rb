# frozen_string_literal: true

module Search
  module Filters
    class Is
      def self.filter(options, value)
        case value
        when "object"
          options[:index_name] = RubyObject
        when "module"
          options[:index_name] = RubyObject
          options[:where][:object_type] = "module_object"
        when "class"
          options[:index_name] = RubyObject
          options[:where][:object_type] = "class_object"
        when "method"
          options[:index_name] = RubyMethod
        when "class-method", "class-method", "cmethod"
          options[:index_name] = RubyMethod
          options[:where][:method_type] = "class_method"
        when "instance-method", "instance-method", "imethod", "#"
          options[:index_name] = RubyMethod
          options[:where][:method_type] = "instance_method"
        end

        options
      end
    end
  end
end
