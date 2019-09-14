module Search
  class Documentation
    RESULTS_PER_PAGE = 25

    def self.search(query, version:, page:)
      new(query, version: version, page: page).search
    end

    def initialize(query, version:, page:)
      @query = Search::Query.new(query)
      @version = version
      @page = [page.to_i, 1].max
    end

    def search
      print elasticsearch_options.to_json
      search_repository.search(elasticsearch_options)
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
            boost_mode: :multiply,
            query: {
              bool: {
                filter: filters,
                must: {
                  multi_match: {
                    query: @query.terms,
                    type: :bool_prefix,
                    fields: [
                      "name",
                    ]
                  }
                },
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
      Ruby::CORE_CLASSES.map do |constant, weight|
        {
          filter: { term: { "object_constant" => constant.downcase } },
          weight: weight
        }
      end
    end

    def filters
      return [] if @query.filters.empty?

      filters = []
      @query.filters.each do |filter, value|
        next unless filter? filter
        filters << { term: filter_klass_for(filter).filter_for(value) }
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
