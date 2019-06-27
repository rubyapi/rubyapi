# frozen_string_literal: true

module SearchFilter
  class In
    def self.filter(options, value)
      options[:where][:method_parent] = value
      options
    end
  end
end
