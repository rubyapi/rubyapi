# frozen_string_literal: true

class AutocompleteController < ApplicationController
  include SearchHelper

  before_action :enable_public_cache

  def index
    search = Searchkick.search(
      search_query,
      models: [RubyObject, RubyMethod, RubyConstant],
      fields: ["constant_prefix^10", "constant^5", "name^3", "description"],
      match: :word_start,
      boost_by: {
        popularity_boost: {factor: 1},
        type_boost: {factor: 1}
      },
      where: {
        documentable_type: Current.ruby_release.class.name,
        documentable_id: Current.ruby_release.id
      },
      limit: 10
    )

    normalized_results = search.results.map do |result|
      {
        text: result.constant,
        path: result_url(result, release: Current.ruby_release)
      }
    end

    render json: normalized_results
  end

  private

  def search_query
    params[:q] || ""
  end
end
