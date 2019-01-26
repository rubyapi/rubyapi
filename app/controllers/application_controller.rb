class ApplicationController < ActionController::Base
  def ruby_version
    params[:version] || Rails.configuration.default_ruby_version
  end
  helper_method :ruby_version

  def search_query
    params[:q]
  end
  helper_method :search_query

  def available_ruby_versions
    ruby_versions = Rails.configuration.ruby_versions.dup
    ruby_versions.delete(ruby_version)
    ruby_versions
  end
  helper_method :available_ruby_versions

  def route_for_version(version)
    route = Rails.application.routes.recognize_path request.url
    route.merge! only_path: true, version: version
    route.merge! request.query_parameters

    url_for route
  end
  helper_method :route_for_version

  def home_path
    return root_path if Rails.configuration.default_ruby_version == ruby_version
    versioned_root_path(version: ruby_version)
  end
  helper_method :home_path

end
