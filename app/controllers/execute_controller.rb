class ExecuteController < ApplicationController
  def post
    data = HTTP.post(URI.join(ENV["CODERUNTIME_HOST"], "/run").to_s, json: {snippet: params[:snippet], version: ruby_version})
    response = JSON.parse(data)
    render json: {output: response["body"], error: response["error"], status: 0}
  end
end
