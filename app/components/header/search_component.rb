# frozen_string_literal: true

module Header
  class SearchComponent < ViewComponent::Base
    def initialize(release: Current.ruby_release)
      @ruby_release = release
    end

    def homepage?
      current_page?(root_path) || current_page?(versioned_root_path(release: Current.ruby_release.version))
    end

    def search_query
      params[:q] || ""
    end
  end
end
