class SearchConfig < ApplicationConfig
  config_name :opensearch

  attr_config :url,
    number_of_shards: 1,
    number_of_replicas: 1,
    ca_file: nil

  def transport_options
    { ssl: ssl_options }
  end

  def ssl_options
    {
      verify: require_ssl_verification?,
      ca_file: ca_file
    }
  end

  def require_ssl_verification?
    Rails.env.production?
  end
end
