# frozen_string_literal: true

class SearchRepository
  include Elasticsearch::Persistence::Repository
  include Elasticsearch::Persistence::Repository::DSL

  settings(
    number_of_shards: Rails.configuration.elasticsearch_shards,
    number_of_replicas: Rails.configuration.elasticsearch_replicas,
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
          pattern: "(\:\:)|(#)|(_)"
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
      indexes :object_constant, type: :text, analyzer: :keyword
      indexes :method_identifier, type: :keyword, normalizer: :lowercase
      indexes :object_type, type: :keyword
      indexes :method_type, type: :keyword
    end
  end

  def self.repository_for_version(version)
    new(index_name: "search_#{version}_#{Rails.env}")
  end

  def deserialize(document)
    document.deep_symbolize_keys!
    klass_for_document(document).new(document[:_source])
  end

  def bulk_import(records)
    records.each_slice(500) do |slice|
      entries = slice.each_with_object([]) { |o, arr| arr.push(o.to_hash, *o.ruby_methods.map(&:to_hash)) }
      payload = entries.flat_map { |o| [{index: {}}, o.to_hash] }
      client.bulk(body: payload, index: index_name)
    end
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
