# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_ruby_version, :set_feature_flags
  after_action :set_feature_headers

  protect_from_forgery with: :exception

  def set_ruby_version
    if params[:version] == "current"
      permitted_params = params.permit(:object, :engine, :q, :page, :theme)
      redirect_to permitted_params.merge(version: RubyConfig.default_ruby_version.version)
      return
    end

    version = RubyConfig.version_for(params[:version]) || RubyConfig.default_ruby_version

    Current.ruby_version = version
    Current.default_ruby_version = RubyConfig.default_ruby_version
  end

  def set_feature_flags
    Current.enable_method_signatures = ActiveModel::Type::Boolean.new.cast(cookies[:signatures] || request.env["HTTP_X_RUBYAPI_SIGNATURES"] || false)
    Current.theme = ThemeConfig.theme_for(cookies[:theme] || request.env["HTTP_X_RUBYAPI_THEME"] || "system")
  end
  helper_method :ruby_version

  def set_feature_headers
    headers["X-RubyAPI-Signatures"] = Current.enable_method_signatures
    headers["X-RubyAPI-Theme"] = Current.theme.name
    headers["Vary"] = "X-RubyAPI-Signatures, X-RubyAPI-Theme"
  end

  def enable_public_cache
    expires_in 24.hours, public: true
  end

  def enable_private_cache
    expires_in 24.hours, public: false
  end
end
