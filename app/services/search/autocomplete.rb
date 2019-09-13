module Search
  class Autocomplete
    def self.search(query, version: version)
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
          multi_match: {
            query: @query.terms,
            type: :most_fields,
            fields: [
              "name^3",
              "autocomplete",
              "autocomplete.2gram"
            ]
          }
        }
      }
    end
  end
end
