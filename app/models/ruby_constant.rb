# frozen_string_literal: true

class RubyConstant < Dry::Struct
  attribute :name, Types::String
  attribute :description, Types::String
end
