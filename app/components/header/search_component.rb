# frozen_string_literal: true
module Header
  class SearchComponent < ViewComponent::Base
    def initialize(ruby_version:)
      @ruby_version = ruby_version
    end

    def homepage?
      current_page?(root_path) || current_page?(versioned_root_path(version: @ruby_version))
    end

    def search_query
      params[:q] || ""
    end
  end
end
