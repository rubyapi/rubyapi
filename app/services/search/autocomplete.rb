module Search
  class Autocomplete
    def self.search(query, version:)
      new(query, version: version).perform
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
                should: {
                  match: {autocomplete: @query.terms.downcase},
                },
                must: {
                  multi_match: {
                    query: @query.terms.downcase,
                    fields: [
                      "autocomplete",
                      "autocomplete.2gram",
                      "autocomplete.3gram",
                    ],
                  },
                },
              },
            },
          },
        },
      }
    end

    def boost_functions
      Ruby::CORE_CLASSES.map do |constant, weight|
        {
          filter: {term: {"object_constant" => constant}},
          weight: weight,
        }
      end
    end
  end
end
