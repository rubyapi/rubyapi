class SearchConfig < ApplicationConfig
  attr_accessor :client


  attr_config driver: "elasticsearch"
  attr_config url: "http://localhost:9200", number_of_shards: 1, number_of_replicas: 1, sigv4: false
  attr_config user: "admin", password: "admin"

  on_load :set_client

  def driver
    values[:driver].inquiry
  end

  private

  def set_client
    self.client = search_client
  end

  def search_client
    if driver.elasticsearch?
      Elasticsearch::Client.new(host: url)
    elsif driver.opensearch?
      if sigv4?
        OpenSearch::Aws::Sigv4Client.new({host: url, transport_options: transport_options, log: true}, signer)
      else
        OpenSearch::Client.new(host: url, user: user, password: password, transport_options: transport_options)
      end
    end
  end

  def signer
    Aws::Sigv4::Signer.new(
      service: 'es',
      region: AwsConfig.region,
      credentials_provider: AwsConfig.authentication_provider
    )
  end

  def transport_options
    { ssl: ssl_options }
  end

  def ssl_options
    {
      verify: require_ssl_verification?,
    }
  end

  def require_ssl_verification?
    Rails.env.production?
  end
end
