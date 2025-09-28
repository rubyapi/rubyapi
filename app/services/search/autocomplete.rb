# frozen_string_literal: true

module Search
  class Autocomplete
    def self.search(query, release:)
      new(query, release:).perform
    end

    def initialize(query, release:)
      @query = Search::Query.new(query)
      @release = release
    end

    def perform
      Elasticsearch::Persistence::Repository::Response::Results.new(search_repository, client.search(index:, body:))
    end

    private

    def client
      SearchConfig.client
    end

    def index
      search_repository.index_name
    end

    def search_repository
      @search_repository ||= SearchRepository.repository_for_release(@release)
    end

    def body
      {
        query: {
          function_score: {
            functions: boost_functions,
            query: {
              bool: {
                should: [
                  {match: {autocomplete: @query.terms}},
                  {match: {type: {query: :object, boost: 1.5}}}
                ],
                must: {
                  multi_match: {
                    query: @query.terms,
                    type: :bool_prefix,
                    fields: [
                      "autocomplete",
                      "autocomplete._2gram"
                    ]
                  }
                }
              }
            }
          }
        }
      }
    end

    def boost_functions
      Ruby::CORE_CLASSES.map do |constant, weight|
        {
          filter: {term: {"object_constant" => constant}},
          weight:
        }
      end
    end
  end
end
