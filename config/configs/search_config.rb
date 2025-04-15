class SearchConfig < ApplicationConfig
  # host URL configuration is set through the OPENSEARCH_URL environment variable

  attr_config number_of_shards: 1, number_of_replicas: 1
  attr_config ca_file: nil

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
