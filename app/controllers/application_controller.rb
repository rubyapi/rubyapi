# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_ruby_version, :set_feature_flags
  after_action :set_feature_headers

  def set_ruby_version
    version = RubyConfig.version_for(params[:version]) || RubyConfig.default_ruby_version

    Current.ruby_version = version
    Current.default_ruby_version = RubyConfig.default_ruby_version
  end

  def set_feature_flags
    @show_signatures = ActiveModel::Type::Boolean.new.cast(cookies[:signatures] || request.env["HTTP_X_RUBYAPI_SIGNATURES"] || false)
  end

  def set_feature_headers
    headers["X-RubyAPI-Signatures"] = @show_signatures
    headers["Vary"] = "X-RubyAPI-Signatures"
  end

  def enable_public_cache
    expires_in 24.hours, public: true
  end

  def enable_private_cache
    expires_in 24.hours, public: false
  end
end
