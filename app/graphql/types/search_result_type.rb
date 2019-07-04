module Types::SearchResultType
  include Types::BaseInterface

  field :name, String, "Result title", null: false
  field :description, String, "Result description body", null: true
  field :version, String, "Result Ruby version", null: false

  definition_methods do
    # Optional: if this method is defined, it overrides `Schema.resolve_type`
    def resolve_type(object, context)
      if object.is_a? RubyObject
        Types::RubyObjectType
      elsif object.is_a? RubyMethod
        Types::RubyMethodType
      else
        raise "Unexpected SearchResultType: #{object.inspect}"
      end
    end
  end
end
