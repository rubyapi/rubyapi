# frozen_string_literal: true

class SearchController < ApplicationController
  MAX_SEARCH_QUERY_LENGTH = 255

  before_action :index, -> { redirect_to root_path unless search_query.present? }
  before_action :index, -> { head :bad_request if search_query.length >= MAX_SEARCH_QUERY_LENGTH }

  def index
    @search = Search::Documentation.search search_query, version: ruby_version, page: current_page
  end

  def pagination
    Kaminari.paginate_array([], total_count: @search.total).page(current_page).per(results_per_page)
  end

  helper_method :pagination

  private

  def results_per_page
    Search::Documentation::RESULTS_PER_PAGE
  end

  def current_page
    params[:page].to_i
  end
end
