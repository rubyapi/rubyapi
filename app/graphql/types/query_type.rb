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
      document = Base64.encode64(constant)
      ruby_object_repository(version: version).find(document)
    end

    def search(query:, version:, page:)
      Search::Documentation.search(query, version: version, page: page)
    end

    def autocomplete(query:, version:)
      results = Search::Autocomplete.search(query, version: version).first(5)
      results.map { |r| AutocompleteResult.new(r, version: version) }
    end

    def ruby_object_repository(version:)
      @ruby_object_repository ||= RubyObjectRepository.repository_for_version(version)
    end
  end
end
