class ElasticsearchConfig < ApplicationConfig
  attr_config url: "http://localhost:9200", number_of_shards: 1,
    number_of_replicas: 1
end