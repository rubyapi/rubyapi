# frozen_string_literal: true

# Filter results (methods only) by their object
# Example:
#
#   to_i in:String
#

module Search
  module Filters
    class In
      def self.filter_for(value)
        [
          {term: {object_constant: {value:}}},
          {term: {type: {value: :method}}}
        ]
      end
    end
  end
end
