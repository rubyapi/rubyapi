# frozen_string_literal: true

Rails.application.routes.draw do
  mount MaintenanceTasks::Engine, at: "/maintenance_tasks"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  get "up" => "rails/health#show", as: :rails_health_check

  ruby_versions = RubyConfig.versions.map { Regexp.escape(it[:version].to_s) }

  scope "(:version)", constraints: { version: /#{ruby_versions.join("|")}/ } do
    root to: "home#index", as: :versioned_root
    post "/set_theme", to: "home#set_theme"
    # We need the search path to be prefixed with `o/` so that the RDOc links will
    # function correctly
    post "o/toggle_signatures", to: "objects#toggle_signatures", as: :toggle_signatures
    get "o/*object", to: "objects#show", as: :object
    get "a", to: "autocomplete#index", as: :autocomplete, default: { format: :json }

    post "/run", to: "code_execute#post"
  end
end
