# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  get "up" => "rails/health#show", as: :rails_health_check

  scope "(:version)", version: /[0-9]+\.[0-9]+|dev/ do
    root to: "home#index", as: :versioned_root
    post '/set_theme', to: 'home#set_theme'
    # We need the search path to be prefixed with `o/` so that the RDOc links will
    # function correctly
    get "o/s", to: "search#index", as: :search
    post "o/toggle_signatures", to: "objects#toggle_signatures", as: :toggle_signatures
    get "o/*object", to: "objects#show", as: :object
    get "a", to: "autocomplete#index", as: :autocomplete, default: {format: :json}
  end
end
