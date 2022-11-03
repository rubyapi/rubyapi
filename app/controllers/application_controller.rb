# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_ruby_version

  def set_ruby_version
    version = RubyConfig.version_for(params[:version]) || RubyConfig.default_ruby_version

    Current.ruby_version = version
    Current.default_ruby_version = RubyConfig.default_ruby_version
  end

  def home_path
    return root_path if Current.ruby_version.default?
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
