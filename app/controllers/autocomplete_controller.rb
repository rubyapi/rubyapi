# frozen_string_literal: true

class AutocompleteController < ApplicationController
  include SearchHelper

  before_action :enable_public_cache

  def index
    results = Searchkick.search(
      params[:q],
      models: [ RubyObject, RubyMethod, RubyConstant ],
      fields: [ { name: :word_start }, :description, { constant: :word_middle } ],
      where: { ruby_version: Current.ruby_version.version }
    )

    render json: results.first(5).map { render_autocomplete_result(it) }
  end

  private

  def render_autocomplete_result(result)
    {
      text: result.constant,
      path: result_url(result)
    }
  end
end
