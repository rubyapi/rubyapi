# frozen_string_literal: true

module Search
  class Query
    QUERY_OPTION_PATTERN = /\w+:\w+/.freeze

    attr_reader :query

    def initialize(query = "")
      @query = query.to_s.freeze
      @options = Set.new
      @terms = Set.new

      parse_search_query
    end

    def terms
      @cached_terms ||= @terms.uniq.join(" ").gsub(".", "::")
    end

    def filters
      filters = {}
      @options.each do |f|
        key, value = f.split(":")
        filters[key.to_sym] = value
      end

      filters
    end

    private

    def parse_search_query
      @query.strip.split(" ").each do |token|
        if QUERY_OPTION_PATTERN.match?(token)
          @options << token
        else
          @terms << token
        end
      end
    end
  end
end
