class SearchController < ApplicationController
  MAX_SEARCH_QUERY_LENGTH = 255

  before_action :index, -> { redirect_to root_path unless search_query.present? }
  before_action :index, -> { head :bad_request if search_query.length >= MAX_SEARCH_QUERY_LENGTH }

  def index
    @search = DocSearch.perform search_query, version: ruby_version, page: current_page
  end

  def current_page
    params[:page]
  end
end
