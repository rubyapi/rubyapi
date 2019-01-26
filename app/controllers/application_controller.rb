class ApplicationController < ActionController::Base
  def ruby_version
    params[:version] || Rails.configuration.default_ruby_version
  end
  helper_method :ruby_version

  def search_query
    params[:q]
  end
  helper_method :search_query
end
