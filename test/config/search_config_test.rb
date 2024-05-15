require "test_helper"

class SearchConfigTest < ActiveSupport::TestCase
  include Anyway::Testing::Helpers

  test "search client" do
    with_env(
      "SEARCH_URL" => "https://localhost:9600",
      "SEARCH_DRIVER" => "opensearch"
    ) do
      client = SearchConfig.new.client
      assert_kind_of OpenSearch::Client, client
    end
  end

  test "search client with sigv4" do
    skip "This test is flaky and has a bug in the anyway gem"

    with_env(
      "SEARCH_URL" => "https://localhost:9600",
      "SEARCH_SIGV4" => "true",
      "AWS_REGION" => "us-east-1",
      "SEARCH_DRIVER" => "opensearch"
    ) do
      client = SearchConfig.new.client
      assert_kind_of OpenSearch::Aws::Sigv4Client, client
    end
  end

  test "search client with sigv4 and configured aws credentials" do
    with_env(
      "SEARCH_DRIVER" => "opensearch",
      "SEARCH_SIGV4" => "true",
      "AWS_ACCESS_KEY_ID" => "access_key_id",
      "AWS_SECRET_ACCESS_KEY" => "secret_access_key",
      "AWS_REGION" => "region"
    ) do
      skip "This test is flaky and has a bug in the anyway gem"

      client = SearchConfig.new.client
      credentials = client.sigv4_signer.credentials_provider.credentials

      assert_equal "access_key_id", credentials.access_key_id
      assert_equal "secret_access_key", credentials.secret_access_key
      assert_equal "region", client.sigv4_signer.region
    end
  end

  test "setting number of shards" do
    with_env(
      "SEARCH_URL" => "https://localhost:9600",
      "SEARCH_NUMBER_OF_SHARDS" => "2"
    ) do
      assert_equal 2, SearchConfig.new.number_of_shards
    end
  end

  test "setting number of replicas" do
    with_env(
      "SEARCH_URL" => "https://localhost:9600",
      "SEARCH_NUMBER_OF_REPLICAS" => "2"
    ) do
      assert_equal 2, SearchConfig.new.number_of_replicas
    end
  end

  test "setting the CA path" do
    with_env(
      "SEARCH_CA_PATH" => "/etc/ssl/certs/ca-certificates.crt"
    ) do

      assert_equal "/etc/ssl/certs/ca-certificates.crt", SearchConfig.new.ca_path
      assert SearchConfig.new.client.transport.transport.options[:transport_options][:ssl][:ca_path]
    end
  end
end
