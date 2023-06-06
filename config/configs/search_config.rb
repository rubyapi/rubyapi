class SearchConfig < ApplicationConfig
  attr_accessor :client

  attr_config url: "http://localhost:9200", number_of_shards: 1, number_of_replicas: 1, sigv4: false

  on_load :set_client

  private

  def set_client
    self.client = search_client
  end

  def search_client
    if sigv4_enabled?
      OpenSearch::Aws::Sigv4Client.new({host: url, log: true}, signer)
    else
      OpenSearch::Client.new(url: url)
    end
  end

  def signer
    Aws::Sigv4::Signer.new(
      service: 'es',
      region: AwsConfig.region,
      access_key_id: AwsConfig.credentials.access_key_id,
      secret_access_key: AwsConfig.credentials.secret_access_key,
    )
  end

  def sigv4_enabled?
    sigv4.present?
  end
end
