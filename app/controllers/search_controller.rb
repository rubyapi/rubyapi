# frozen_string_literal: true

class SearchController < ApplicationController
  MAX_SEARCH_QUERY_LENGTH = 255

  before_action :index, -> { redirect_to root_path unless search_query.present? }
  before_action :index, -> { head :bad_request if search_query.length >= MAX_SEARCH_QUERY_LENGTH }

  def index
    @search = Search::Documentation.search search_query, version: ruby_version, page: current_page
  end

  def results_per_page
    Search::Documentation::RESULTS_PER_PAGE
  end

  helper_method :results_per_page

  def current_page
    params[:page]
  end

  helper_method :current_page
end
