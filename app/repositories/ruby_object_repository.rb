# frozen_string_literal: true

class RubyObjectRepository
  include Elasticsearch::Persistence::Repository
  include Elasticsearch::Persistence::Repository::DSL

  klass RubyObject

  settings number_of_shards: ElasticsearchConfig.number_of_shards, number_of_replicas: ElasticsearchConfig.number_of_replicas do
    mapping do
      indexes :name, type: :text
      indexes :description, type: :text, index: false
      indexes :ruby_methods, type: :nested
      indexes :superclass, type: :nested
      indexes :included_modules, type: :nested
      indexes :metadata, type: :nested
    end
  end

  def self.repository_for_version(version)
    new(index_name: "ruby_objects_#{version}_#{Rails.env}")
  end

  def bulk_import(objects)
    payload = objects.flat_map { |o| [{index: {"_id" => o.id}}, o.to_hash] }
    client.bulk(body: payload, index: index_name)
  end

  def deserialize(document)
    document.deep_symbolize_keys!
    klass.new(document[:_source])
  end
end
