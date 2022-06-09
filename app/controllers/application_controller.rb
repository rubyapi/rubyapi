# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def ruby_version
    params[:version] || default_ruby_version
  end
  helper_method :ruby_version

  def default_ruby_version
    RubyConfig.default_ruby_version.version
  end
  helper_method :default_ruby_version

  def search_query
    params[:q] || ""
  end
  helper_method :search_query

  def supported_ruby_versions
    RubyConfig.active_ruby_versions.map(&:version)
  end
  helper_method :supported_ruby_versions

  def eol_ruby_versions
    RubyConfig.eol_ruby_versions.map(&:version)
  end
  helper_method :eol_ruby_versions

  def route_for_version(version)
    route = Rails.application.routes.recognize_path request.url
    route[:only_path] = true
    route[:version] = version
    route.merge! request.query_parameters

    url_for route
  end
  helper_method :route_for_version

  def home_path
    return root_path if RubyConfig.default_ruby_version.version == ruby_version
    versioned_root_path(version: ruby_version)
  end
  helper_method :home_path

  def skip_session
    request.session_options[:skip] = true
  end

  def enable_public_cache
    skip_session
    expires_in 24.hours, public: true
  end
end
