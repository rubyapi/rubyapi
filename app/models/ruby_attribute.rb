# frozen_string_literal: true

class RubyAttribute < Dry::Struct
  attribute :name, Types::String
  attribute :description, Types::String
  attribute :access, Types::String.default("public")
end
