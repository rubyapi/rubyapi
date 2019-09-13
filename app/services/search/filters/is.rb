# frozen_string_literal: true

module Search
  module Filters
    class Is
      def self.filter_for(value)
        case value
        when "object"
          { type: :object }
        when "module"
          { "type" => "object", "metadata.object_type" => "module_object" }
        when "class"
          { "type" => "object", "metadata.object_type" => "class_object" }
        when "method"
          { type: :method }
        when "class-method", "class-method", "cmethod"
          { "type" => "method", "metadata.method_type" => "class_method" }
        when "instance-method", "instance-method", "imethod", "#"
          { "type" => "method", "metadata.method_type" => "instance_method" }
        end
      end
    end
  end
end
