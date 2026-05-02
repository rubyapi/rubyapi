ENV["OPENSEARCH_URL"] ||= SearchConfig.url
Searchkick.client_options[:transport_options] = SearchConfig.transport_options
