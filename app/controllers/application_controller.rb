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

  def home_path
    return root_path if RubyConfig.default_ruby_version.version == ruby_version
    versioned_root_path(version: ruby_version)
  end
  helper_method :home_path

  def enable_public_cache
    expires_in 24.hours, public: true
  end

  def enable_private_cache
    expires_in 24.hours, public: false
  end
end
