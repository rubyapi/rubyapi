# frozen_string_literal: true

module Types
  class RubyMethodType < Types::BaseObject
    implements SearchResultType

    field :name, String, null: false
    field :description, String, null: true
    field :type, String, null: false, method: :method_type
    field :parent_object, [Types::RubyMethodType], null: false
    field :version, String, null: false
  end
end
