# frozen_string_literal: true

class AutocompleteController < ApplicationController
  before_action :enable_public_cache

  def index
    search_results = Search::Autocomplete.search(search_query, version: ruby_version).first(5)
    render json: search_results.map { |r| AutocompleteResult.new(r, version: ruby_version) }
  end

  def search_query
    params[:q] || ""
  end
end
