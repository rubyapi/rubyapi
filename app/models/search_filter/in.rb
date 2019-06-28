# frozen_string_literal: true

# Filter results (methods only) by their object
# Example:
#
#   to_i in:String
#
module SearchFilter
  class In
    def self.filter(options, value)
      options[:where][:parent_name] = value
      options
    end
  end
end
