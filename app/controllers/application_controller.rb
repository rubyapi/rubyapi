class ApplicationController < ActionController::Base
  def ruby_version
    params[:version] || Rails.configuration.default_ruby_version
  end
end
