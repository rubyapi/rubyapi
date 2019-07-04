module Types
  class RubyObjectType < Types::BaseObject
    implements SearchResultType

    field :name, String, null: false
    field :type, String, null: false
    field :description, String, null: true
    field :constant, String, null: false
    field :version, String, null: false
    field :ruby_methods, [Types::RubyMethodType], null: false
  end
end
