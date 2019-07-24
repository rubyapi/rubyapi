module Types
  class AutocompleteSearchResultType < Types::BaseObject
    include SearchHelper

    field :text, String, null: false
    field :path, String, null: false

    def path
      result_url object
    end

    def text
      if object.is_a?(RubyObject)
        object.constant
      elsif object.is_a?(RubyMethod)
        [object.ruby_object.constant, object.type_identifier, object.name].join
      end
    end
  end
end
