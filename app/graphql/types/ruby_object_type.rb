# frozen_string_literal: true

module Types
  class RubyObjectType < Types::BaseObject
    implements SearchResultType

    field :name, String, null: false
    field :type, String, null: false
    field :description, String, null: true
    field :constant, String, null: false
    field :superclass, String, null: true
    field :included_modules, [String], null: false
    field :version, String, null: false
    field :ruby_methods, [Types::RubyMethodType], null: false
    field :path, String, null: false

    def path
      routes = Rails.application.routes.url_helpers
      routes.object_path version: object.version, object:
    end
  end
end
