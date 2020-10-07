# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"

Dir.glob(Rails.root.join("lib/*.rb")).each { |f| require_relative f }

WebMock.disable!

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  def create_index_for_version!(version)
    search_repository(version).create_index! force: true
    ruby_object_repository(version).create_index! force: true
  end

  def default_ruby_version
    Rails.configuration.default_ruby_version
  end

  def index_search(object, version: nil)
    search_repository(version).save object
  end

  def index_object(object, version: nil)
    ruby_object_repository(version).save object
  end

  def search_repository(version = nil)
    version ||= default_ruby_version
    SearchRepository.repository_for_version(version)
  end

  def ruby_object_repository(version = nil)
    version ||= default_ruby_version
    RubyObjectRepository.repository_for_version(version)
  end

  def ruby_object(constant, object_type: :class)
    raise ArgumentError unless [:class, :module].include?(object_type)
    name = constant.to_s.split("::").first

    attributes = {
      name: name,
      description: "<h1>Hello Object: #{name}</h1>",
      object_type: "#{object_type}_object",
      constant: constant.to_s,
      superclass: constant.superclass.to_s,
      included_modules: constant.included_modules.map(&:to_s),
      metadata: {
        depth: 1
      },
      attributes: [
        {name: "path", description: "<p>Path description</p>", access: "read"}
      ],
      constants: [
        {name: "HELLO_WORLD", description: "<p>Hello World!</p>"}
      ],
      methods: [
        {
          name: "new",
          description: "<h1>Hello World!</h1>",
          method_type: "class_method",
          object_constant: constant.to_s,
          source_location: "2.6.4:string.c:3",
          metadata: {
            depth: 1
          },
          call_sequence: []
        }, {
          name: "empty?",
          description: "<h1>Hello World!</h1>",
          method_type: "instance_method",
          object_constant: constant.to_s,
          source_location: "2.6.4:string.c:76",
          metadata: {
            depth: 1
          },
          call_sequence: []
        }, {
          name: "to_i",
          description: "<h1>Hello World</h1>",
          method_type: "instance_method",
          object_constant: constant.to_s,
          source_location: "2.6.4:string.c:54",
          metadata: {
            depth: 1
          },
          call_sequence: [
            "str.to_i # => 1"
          ]
        }
      ]
    }

    RubyObject.new(attributes)
  end
end
