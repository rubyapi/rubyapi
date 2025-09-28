# frozen_string_literal: true

class Header::VersionSelectorComponent < ViewComponent::Base
  def initialize(releases: RubyRelease.ordered, current_release: Current.ruby_release)
    @ruby_releases = releases
    @current_release = current_release
  end

  def route_for_version(release)
    route = Rails.application.routes.recognize_path request.url
    route[:only_path] = true
    route[:version] = release.version
    route.merge! request.query_parameters

    url_for route
  end
end
