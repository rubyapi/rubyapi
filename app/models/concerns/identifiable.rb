# frozen_string_literal: true

# This concerns encapsulates methods that allows us to build IDs & URL paths for RubyObjects, SuperClasses & Included Modules
# that can be used in URLs and ElasticSearch
module Identifiable
  extend ActiveSupport::Concern

  included do
    attribute :id, Types::String.optional.default(nil) # This field is automatically generated
    attribute :path, Types::String.optional.default(nil) # This field is automatically generated

    def initialize(attributes)
      attributes[:path] = self.class.path_from_constant(attributes[:constant])
      attributes[:id] = self.class.id_from_path(attributes[:path])

      super(attributes)
    end
  end

  class_methods do
    def id_from_path(path)
      Base64.strict_encode64(path)
    end

    def path_from_constant(constant)
      constant&.downcase&.gsub(/::/, "/")
    end
  end
end
