# frozen_string_literal: true

require_relative "environment"

if GC.respond_to?(:compact)
  GC.compact
end

