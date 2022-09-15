# frozen_string_literal: true

class Header::VersionSelectorComponent < ViewComponent::Base
  def initialize(current_version:, versions: nil)
    @current_version = current_version
    @ruby_versions = versions
  end

  def route_for_version(version)
    route = Rails.application.routes.recognize_path request.url
    route[:only_path] = true
    route[:version] = version
    route.merge! request.query_parameters

    url_for route
  end
end
