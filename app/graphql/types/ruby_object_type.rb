module Types
  class RubyObjectType < Types::BaseObject
    field :name, String, null: true
    field :type, String, null: true
    field :description, String, null: true
    field :constant, String, null: true
    field :version, String, null: true
    field :ruby_methods, [Types::RubyMethodType], null: true
  end
end
