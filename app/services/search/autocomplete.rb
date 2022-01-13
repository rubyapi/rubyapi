# frozen_string_literal: true

module Search
  class Autocomplete
    def self.search(query, version:)
      new(query, version:).perform
    end

    def initialize(query, version:)
      @query = Search::Query.new(query)
      @version = version
    end

    def perform
      search_repository.search(elasticsearch_query)
    end

    private

    def search_repository
      @search_repository ||= SearchRepository.repository_for_version(@version)
    end

    def elasticsearch_query
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
