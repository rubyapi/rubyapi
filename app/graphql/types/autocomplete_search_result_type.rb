module Types
  class AutocompleteSearchResultType < Types::BaseObject
    field :text, String, null: false
    field :path, String, null: false

    def path
      object.path
    end

    def text
      object.autocomplete
    end
  end
end
