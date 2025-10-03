require "test_helper"

class SearchConfigTest < ActiveSupport::TestCase
  include Anyway::Testing::Helpers

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
      "SEARCH_CA_FILE" => "/etc/ssl/certs/ca-certificates.crt"
    ) do
      assert_equal "/etc/ssl/certs/ca-certificates.crt", SearchConfig.new.ca_file
      assert SearchConfig.new.transport_options[:ssl][:ca_file]
    end
  end
end
