
require_relative "environment"

if GC.respond_to?(:compact)
  GC.compact
end

