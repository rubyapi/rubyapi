class RubyApiSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
