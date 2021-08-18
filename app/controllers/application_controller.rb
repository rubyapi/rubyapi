# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def ruby_version
    params[:version] || Rails.configuration.default_ruby_version
  end
  helper_method :ruby_version

  def default_ruby_version
    Rails.configuration.default_ruby_version
  end
  helper_method :default_ruby_version

  def search_query
    params[:q] || ""
  end
  helper_method :search_query

  def supported_ruby_versions
    ruby_versions = Rails.configuration.ruby_versions.dup
    other_versions = eol_ruby_versions.dup.push(ruby_version)

    ruby_versions - other_versions
  end
  helper_method :supported_ruby_versions

  def eol_ruby_versions
    Rails.configuration.eol_ruby_versions
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
    return root_path if Rails.configuration.default_ruby_version == ruby_version
    versioned_root_path(version: ruby_version)
  end
  helper_method :home_path

  def object_exists?(klass)
    path = klass.is_a?(RubyObject) ? klass.id : RubyObject.id_from_path(klass)
    !!RubyObjectRepository.repository_for_version(ruby_version).find(path)
  rescue Elasticsearch::Persistence::Repository::DocumentNotFound
    false
  end
  helper_method :object_exists?

  def skip_session
    request.session_options[:skip] = true
  end

  def enable_public_cache
    skip_session
    expires_in 24.hours, public: true
  end
end
