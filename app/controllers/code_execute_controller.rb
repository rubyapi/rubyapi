# frozen_string_literal: true

class CodeExecuteController < ApplicationController
  REPL_PATH = "exec/%{engine}"

  def post
    response = HTTP.headers("x-api-key" => ReplConfig.api_key).post(repl_endpoint, body: params[:snippet])
    execution_result = JSON.parse(response.body.to_str, symbolize_names: true)
    render json: {output: execution_result[:output], error: execution_result[:error], status: execution_result[:status]}
  end

  private

  def repl_endpoint
    URI.join(ReplConfig.url, repl_path).to_s
  end

  def repl_path
    REPL_PATH % {engine:}
  end

  def engine
    params[:engine].present? ? params[:engine] : "mri"
  end
end
