# frozen_string_literal: true

# This class is a minimal class of RubyObject that simply holds a reference to an Object's parent class
class RubyObjectSuperclass < Dry::Struct
  include Identifiable

  attribute :constant, Types::String
end
