Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  root to: "home#index"

  ruby_versions = Rails.configuration.ruby_versions.collect { |v| Regexp.escape(v) }

  scope "(:version)", constraints: { version: /#{ruby_versions.join("|")}/ } do
    root to: "home#index", as: :versioned_root
    # We need the search path to be prefixed with `o/` so that the RDOc links will
    # function correctly
    get "o/s", to: "search#index", as: :search
    get "o/*object", to: "objects#show", as: :object
  end
end
