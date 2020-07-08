# frozen_string_literal: true

class RubyObjectRepository
  include Elasticsearch::Persistence::Repository
  include Elasticsearch::Persistence::Repository::DSL

  klass RubyObject

  settings number_of_shards: Rails.configuration.elasticsearch_shards, number_of_replicas: Rails.configuration.elasticsearch_replicas do
    mapping do
      indexes :name, type: :text
      indexes :description, type: :text, index: false
      indexes :methods, type: :nested
      indexes :superclass, type: :text
      indexes :included_modules, type: :text
      indexes :metadata, type: :nested
    end
  end

  def self.repository_for_version(version)
    new(index_name: "ruby_objects_#{version}_#{Rails.env}")
  end

  def deserialize(document)
    document.deep_symbolize_keys!
    klass.new(document[:_source])
  end
end
