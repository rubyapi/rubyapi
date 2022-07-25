# frozen_string_literal: true

# This class is a minimal class of RubyObject that simply holds a reference to any modules included in an Object
class RubyObjectIncludedModule < Dry::Struct
  include Identifiable

  attribute :constant, Types::String
end
