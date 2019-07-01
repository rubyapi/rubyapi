module Types
  class QueryType < Types::BaseObject
    field :rubyObject, Types::RubyObjectType, null: true do
      argument :constant, String, required: true
      argument :version, String, required: false, default_value: Rails.configuration.default_ruby_version
    end

    def ruby_object(constant:, version:)
      RubyObject.find_by constant: constant, version: version
    end
  end
end
