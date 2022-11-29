# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  get '/ping', to: 'healthcheck#index'
  get '/repl', to: 'repl#index'

  ruby_versions = RubyConfig.ruby_versions.collect { |v| Regexp.escape(v.version) }

  scope "(:version)", constraints: { version: /#{ruby_versions.join("|")}/ } do
    root to: "home#index", as: :versioned_root
    post '/set_theme', to: 'home#set_theme'
    # We need the search path to be prefixed with `o/` so that the RDOc links will
    # function correctly
    get "o/s", to: "search#index", as: :search
    post "o/toggle_signatures", to: "objects#toggle_signatures", as: :toggle_signatures
    get "o/*object", to: "objects#show", as: :object
    get "a", to: "autocomplete#index", as: :autocomplete, default: {format: :json}

    post "/run", to: "code_execute#post"
  end

  get "sitemap.xml.gz", to: redirect("https://#{ENV["AWS_BUCKET_NAME"]}.s3-us-west-2.amazonaws.com/sitemap.xml.gz")
end
