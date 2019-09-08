# frozen_string_literal: true

class SearchRepository
  include Elasticsearch::Persistence::Repository
  include Elasticsearch::Persistence::Repository::DSL

  settings(
      number_of_shards: 5,
      analysis: {
        analyzer: {
          camel: {
            type: :pattern,
            pattern: "([^\\p{L}\\d]+)|(?<=\\D)(?=\\d)|(?<=\\d)(?=\\D)|(?<=[\\p{L}&&[^\\p{Lu}]])(?=\\p{Lu})|(?<=\\p{Lu})(?=\\p{Lu}[\\p{L}&&[^\\p{Lu}]])"
          }
        }
      }) do
    mapping do
      indexes :type, type: :keyword
      indexes :autocomplete, type: :search_as_you_type, analyzer: :camel
      indexes :name, type: :keyword
      indexes :description, type: :text, index: false
      indexes :metadata, type: :nested
    end
  end

  def self.repository_for_version(version)
    new(index_name: "search_#{version}_#{Rails.env}")
  end

  def self.elasticsearch_settings
  end

  def serialize(document)
    document.to_elasticsearch
  end

  def deserialize(document)
    @klass = klass_for_document(document)
    super
  end

  private

  def klass_for_document(document)
    case document["_source"]["type"].to_sym
    when :method
      RubyMethod
    when :object
      RubyObject
    end
  end
end
