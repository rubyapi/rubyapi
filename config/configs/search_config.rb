class SearchConfig < ApplicationConfig
  attr_accessor :client

  attr_config url: "http://localhost:9600", number_of_shards: 1,
    number_of_replicas: 1

  on_load :set_client

  private

  def set_client
    Elasticsearch::Client.new(url: url)
  end
end
