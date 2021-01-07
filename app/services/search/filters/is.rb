# frozen_string_literal: true

module Search
  module Filters
    class Is
      def self.filter_for(value)
        case value
        when "object"
          [{term: {type: {value: :object}}}]
        when "module"
          [{term: {object_type: {value: :module_object}}}]
        when "class"
          [{term: {object_type: {value: :class_object}}}]
        when "method"
          [{term: {type: {value: :method}}}]
        when "class-method", "cmethod"
          [{term: {method_type: {value: :class_method}}}]
        when "instance-method", "imethod", "#"
          [{term: {method_type: {value: :instance_method}}}]
        else
          []
        end
      end
    end
  end
end
