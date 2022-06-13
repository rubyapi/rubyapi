# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  get '/ping', to: 'healthcheck#index'
  get '/repl', to: 'repl#index'

  ruby_versions = RubyConfig.ruby_versions.collect { |v| Regexp.escape(v.version) }

  scope "(:version)", constraints: { version: /#{ruby_versions.join("|")}/ } do
    root to: "home#index", as: :versioned_root
    # We need the search path to be prefixed with `o/` so that the RDOc links will
    # function correctly
    get "o/s", to: "search#index", as: :search
    get "o/*object", to: "objects#show", as: :object

    post "/run", to: "code_execute#post"
  end

  post "/graphql", to: "graphql#execute"

  get "sitemap.xml.gz", to: redirect("https://#{ENV["AWS_BUCKET_NAME"]}.s3-us-west-2.amazonaws.com/sitemap.xml.gz")

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
end
