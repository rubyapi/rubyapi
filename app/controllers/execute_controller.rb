# frozen_string_literal: true

class ExecuteController < ApplicationController
  REPL_PATH = "exec/%{engine}/%{version}"

  def post
    response = HTTP.headers("x-api-key" => repl_api_key).post(repl_endpoint, body: params[:snippet])
    execution_result = JSON.parse(response.body.to_str, symbolize_names: true)
    render json: {output: execution_result[:output], error: execution_result[:error], status: execution_result[:status]}
  end

  private

  def repl_api_key
    Rails.configuration.repl_api_key
  end

  def repl_endpoint
    URI.join(repl_host, repl_path).to_s
  end

  def repl_path
    REPL_PATH % { engine: "mri", version: version }
  end

  def version
    v = params[:version].present? ? params[:version] : default_ruby_version
    Gem::Version.new(v).canonical_segments.join
  end

  def repl_host
    Rails.configuration.repl_host
  end
end
