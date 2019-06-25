class SearchController < ApplicationController
  include Search

  MAX_SEARCH_QUERY_LENGTH = 255

  before_action :index, -> { redirect_to root_path unless search_query.present? }
  before_action :index, -> { head :bad_request if search_query.length >= MAX_SEARCH_QUERY_LENGTH }

  def index
    @search = search_results
  end

  def current_page
    params[:page]
  end
end
