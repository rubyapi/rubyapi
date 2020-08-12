# frozen_string_literal: true

require_relative "ruby_description_cleaner"

class RubyAPIRDocGenerator
  SKIP_NAMESPACES = [
    /Bundler::.*/,
    /RDoc::.*/,
    /IRB::.*/
  ].freeze

  SKIP_NAMESPACE_REGEX = Regexp.union(SKIP_NAMESPACES).freeze

  def class_dir
  end

  def file_dir
  end

  def initialize(store, options)
    @store = store
    @options = options
    @release = options.generator_options.pop
    @version = @release.minor_version
    @documentation = store.all_classes_and_modules
  end

  def generate
    reset_indexes!

    generate_objects.compact.each do |object|
      index_object(object)
    end
  end

  def generate_objects
    objects = []

    @documentation.each do |doc|
      next if skip_namespace? doc.full_name
      methods = []

      doc.method_list.each do |method_doc|
        method = {
          name: method_doc.name,
          description: clean_description(doc.full_name, method_doc.description),
          object_constant: doc.full_name,
          method_type: "#{method_doc.type}_method",
          source_location: "#{@release.version}:#{method_path(method_doc)}:#{method_doc.line}",
          call_sequence: method_doc.call_seq ? method_doc.call_seq.strip.split("\n").map { |s| s.gsub "->", "→" } : "",
          metadata: {
            depth: constant_depth(doc.full_name)
          }
        }

        next if methods.any? { |m| m[:name] == method[:name] && m[:method_type] == method[:method_type] }

        methods << method
      end

      superclass =
        if doc.type == "class"
          case doc.superclass
          when NilClass then nil
          when String then doc.superclass
          else doc.superclass.name
          end
        end

      objects << RubyObject.new(
        name: doc.name,
        description: clean_description(doc.full_name, doc.description),
        methods: methods,
        constant: doc.full_name,
        object_type: "#{doc.type}_object",
        superclass: superclass,
        included_modules: doc.includes.map(&:name),
        constants: doc.constants.each_with_object([]) { |c,arr| arr << { name: c.name, description: clean_description(doc.full_name, c.description) } },
        metadata: {
          depth: constant_depth(doc.full_name)
        }
      )
    end

    objects
  end

  private

  def index_object(object)
    object_repository.save(object)
    search_repository.save(object)

    object.ruby_methods.each { |m| search_repository.save m }
  end

  def object_repository
    @object_repository ||= RubyObjectRepository.repository_for_version(@version)
  end

  def search_repository
    @search_repository ||= SearchRepository.repository_for_version(@version)
  end

  def reset_indexes!
    object_repository.create_index! force: true
    search_repository.create_index! force: true
  end

  def method_path(method_doc)
    base_ruby_dir = Pathname.new @options.files.first
    method_file = Pathname.new Rails.root.join(method_doc.file.relative_name)

    method_file.relative_path_from(base_ruby_dir).to_s
  end

  def skip_namespace?(constant)
    SKIP_NAMESPACE_REGEX.match?(constant)
  end

  def constant_depth(constant)
    constant.split("::").size
  end

  def clean_description(method_class, description)
    RubyDescriptionCleaner.clean(@version, method_class, description)
  end
end
