# frozen_string_literal: true

class AutocompleteController < ApplicationController
  before_action :enable_public_cache

  def index
    search_results = Search::Autocomplete.search(search_query, release: Current.ruby_release).first(5)
    render json: search_results.map { |r| AutocompleteResult.new(r, release: Current.ruby_release) }
  end

  def search_query
    params[:q] || ""
  end
end
