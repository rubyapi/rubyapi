module Types
  class QueryType < Types::BaseObject
    field :rubyObject, Types::RubyObjectType, null: true do
      argument :constant, String, required: true
      argument :version, String, required: false, default_value: Rails.configuration.default_ruby_version
    end

    field :search, [Types::SearchResultType], null: true do
      argument :query, String, required: true
      argument :version, String, required: false, default_value: Rails.configuration.default_ruby_version
      argument :page, Integer, required: false, default_value: 1
    end

    field :autocomplete, [Types::AutocompleteSearchResultType], null: true do
      argument :query, String, required: true
      argument :version, String, required: false, default_value: Rails.configuration.default_ruby_version
    end

    def ruby_object(constant:, version:)
      RubyObject.find_by constant: constant, version: version
    end

    def search(query:, version:, page:)
      search = DocSearch.perform(query, version: version, page: page)
      search.results
    end

    def autocomplete(query:, version:)
      results = Autocomplete.search(query, version: version).first(5)
      results.map { |r| AutocompleteResult.new(r, version: version) }
    end
  end
end
