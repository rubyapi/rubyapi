# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :rubyObject, Types::RubyObjectType, null: true, method: :ruby_object do
      argument :constant, String, required: true, description: "Ruby Object constant"
      argument :version, String, required: false, default_value: Rails.configuration.default_ruby_version
    end

    field :search, [Types::SearchResultType], null: true, method: :search do
      argument :query, String, required: true
      argument :version, String, required: false, default_value: Rails.configuration.default_ruby_version
      argument :page, Integer, required: false, default_value: 1
    end

    field :autocomplete, [Types::AutocompleteSearchResultType], null: true, method: :autocomplete do
      argument :query, String, required: true
      argument :version, String, required: false, default_value: Rails.configuration.default_ruby_version
    end

    def ruby_object(constant:, version:)
      document = Base64.encode64(constant)
      ruby_object_repository(version: version).find(document)
    rescue Elasticsearch::Persistence::Repository::DocumentNotFound
      raise GraphQL::ExecutionError, "Ruby object #{constant.inspect} not found for version #{version}"
    end

    def search(query:, version:, page:)
      search = Search::Documentation.search(query, version: version, page: page)
      search.results
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
