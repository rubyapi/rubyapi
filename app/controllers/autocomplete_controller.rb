# frozen_string_literal: true

class AutocompleteController < ApplicationController
  before_action :enable_public_cache

  def index
    search = Searchkick.search(search_query, models: [RubyObject, RubyMethod, RubyConstant])
    render json: search.results
  end

  def search_query
    params[:q] || ""
  end
end
