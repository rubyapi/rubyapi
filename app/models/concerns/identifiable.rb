# This concerns encapsulates methods that allows us to build IDs & URL paths for RubyObjects, SuperClasses & Included Modules
# that can be used in URLs and ElasticSearch
module Identifiable
  extend ActiveSupport::Concern

  included do
    def id
      self.class.id_from_path(path)
    end
  
    def path
      constant&.downcase&.gsub(/::/, "/")
    end
  end

  class_methods do
    def id_from_path(path)
      Base64.strict_encode64(path)
    end
  end
end
