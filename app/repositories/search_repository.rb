# frozen_string_literal: true

class SearchRepository
  include Elasticsearch::Persistence::Repository
  include Elasticsearch::Persistence::Repository::DSL

  settings(
    number_of_shards: SearchConfig.number_of_shards,
    number_of_replicas: SearchConfig.number_of_replicas,
    analysis: {
      normalizer: {
        lowercase: {
          filter: [:lowercase]
        }
      },
      filter: {
        "2gram" => {
          type: :ngram,
          min_gram: 2,
          max_gram: 2
        },
        "3gram" => {
          type: :ngram,
          min_gram: 3,
          max_gram: 3
        }
      },
      tokenizer: {
        method_name: {
          type: :pattern,
          pattern: "(_)"
        }
      },
      analyzer: {
        :name => {
          type: :custom,
          tokenizer: :method_name,
          filter: [:lowercase]
        },
        "name2gram" => {
          type: :custom,
          tokenizer: :method_name,
          filter: [:lowercase, "2gram"]
        },
        "name3gram" => {
          type: :custom,
          tokenizer: :method_name,
          filter: [:lowercase, "3gram"]
        },
        :autocomplete => {
          type: :pattern,
          pattern: "(::)|(#)|(_)"
        }
      }
    }
  ) do
    mapping do
      indexes :type, type: :keyword
      indexes :autocomplete, type: :search_as_you_type, analyzer: :autocomplete
      indexes :name, type: :text, analyzer: :name, fields: {
        :keyword => {
          type: :keyword,
          normalizer: :lowercase
        },
        "2gram" => {
          type: :text,
          analyzer: "name2gram"
        },
        "3gram" => {
          type: :text,
          analyzer: "name3gram"
        }
      }
      indexes :object_type, type: :keyword
      indexes :method_type, type: :keyword
    end
  end

  def self.repository_for_release(release)
    new(client: SearchConfig.client, index_name: "search_#{release.version}_#{Rails.env}")
  end

  def deserialize(document)
    document.deep_symbolize_keys!
    klass_for_document(document).new(document[:_source])
  end

  def bulk_import(records, wait_for_refresh: false)
    records.each_slice(500) do |slice|
      entries = slice.each_with_object([]) { |o, arr| arr.push(o.to_search, *o.ruby_methods.map(&:to_search)) }
      payload = entries.flat_map { |o| [{index: {}}, o.to_hash] }
      client.bulk(body: payload, index: index_name, refresh: wait_for_refresh)
    end
  end

  def search(query_or_definition, options = {})
    request = {index: index_name, body: query_or_definition.to_hash}
    Response::Results.new(self, client.search(request.merge(options)))
  end

  private

  def klass_for_document(document)
    case document[:_source][:type].to_sym
    when :method
      RubyMethod
    when :object
      RubyObject
    end
  end
end
