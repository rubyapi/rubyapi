# frozen_string_literal: true

module Search
  class Results
    attr_reader :query

    def initialize(response:, query:)
      @response = response
      @query = query
    end

    delegate :raw_response, to: :@response
    delegate :results, to: :@response
    delegate :total, to: :@response
    delegate :response, to: :@response
  end

  class Documentation
    RESULTS_PER_PAGE = 25

    def self.search(...)
      new(...).search
    end

    def initialize(query, version:, page:)
      @query = Search::Query.new(query)
      @version = version
      @page = [page.to_i, 1].max
    end

    def search
      response = search_repository.search(elasticsearch_options)
      Results.new(response:, query: elasticsearch_options)
    end

    private

    def search_repository
      @search_repository ||= SearchRepository.repository_for_version(@version)
    end

    def elasticsearch_options
      {
        query: {
          function_score: {
            functions: boost_functions,
            query: {
              bool: {
                should: [
                  {match: {type: {query: :object, boost: 3.7}}},
                  {match: {autocomplete: {query: @query.terms, boost: 5}}}
                ],
                must: [
                  multi_match: {
                    query: @query.terms,
                    type: :bool_prefix,
                    fields: [
                      "autocomplete",
                      "name",
                      "name.2gram"
                    ]
                  }
                ] + filters
              }
            }
          }
        },
        from: (@page - 1) * RESULTS_PER_PAGE,
        size: RESULTS_PER_PAGE
      }
    end

    private

    def boost_functions
      boosts = []
      Ruby::CORE_CLASSES.each do |constant, weight|
        boosts << {
          filter: {term: {object_constant: constant}},
          weight:
        }
      end

      boosts << {
        filter: {term: {type: :object}},
        weight: 1.5
      }

      boosts << {
        linear: {
          "metadata.depth" => {
            origin: 1,
            scale: 10
          }
        }
      }

      boosts
    end

    def filters
      return [] if @query.filters.empty?

      filters = []
      @query.filters.each do |filter, value|
        next unless filter? filter
        filters.concat filter_klass_for(filter).filter_for(value)
      end

      filters
    end

    def filter?(klass)
      !!filter_klass_for(klass)
    end

    def filter_klass_for(key)
      case key
      when :in
        Search::Filters::In
      when :is
        Search::Filters::Is
      end
    end
  end
end
