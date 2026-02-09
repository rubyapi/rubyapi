ENV["OPENSEARCH_URL"] ||= Rails.application.credentials.opensearch[:url] if Rails.application.credentials.opensearch
Searchkick.client_options[:transport_options] = SearchConfig.transport_options
