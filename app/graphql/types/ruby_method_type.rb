module Types
  class RubyMethodType < Types::BaseObject
    field :name, String, null: false
    field :description, String, null: false
    field :type, String, null: false
    field :parent_object, [Types::RubyMethodType], null: false
  end
end
