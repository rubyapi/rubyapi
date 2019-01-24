class SearchController < ApplicationController

  RESULTS_PER_PAGE = 50

  before_action :index, -> { redirect_to root_path unless search_query.present? }

  def index
    @search = search_results
  end

  def search_query
    params[:q]
  end
  helper_method :search_query

  private

  def search_results
    Searchkick.search(
      search_query,
      {
        index_name: [RubyObject, RubyMethod],
        where: { version: ruby_version },
        page: current_page,
        per_page: RESULTS_PER_PAGE
      }
    )
  end

  def current_page
    params[:page]
  end
end
