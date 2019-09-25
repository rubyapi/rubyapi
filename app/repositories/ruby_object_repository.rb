# frozen_string_literal: true

class RubyObjectRepository
  include Elasticsearch::Persistence::Repository
  include Elasticsearch::Persistence::Repository::DSL

  klass RubyObject

  settings number_of_shards: 5 do
    mapping do
      indexes :name, type: :text
      indexes :description, type: :text, index: false
      indexes :methods, type: :nested
      indexes :metadata, type: :nested
    end
  end

  def self.repository_for_version(version)
    new(index_name: "ruby_objects_#{version}_#{Rails.env}")
  end
end
