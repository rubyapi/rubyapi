# frozen_string_literal: true

require_relative "ruby_description_cleaner"
require "rouge"

class RubyAPIRDocGenerator
  SKIP_NAMESPACES = %w[
    Bundler
    RDoc
    IRB
  ].freeze

  SKIP_NAMESPACE_REGEX = /^(#{SKIP_NAMESPACES.join('|')})($|::.+)/.freeze

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
      if skip_namespace? doc.full_name
        ImportUI.warn "Skipping #{doc.full_name}"
        next
      end

      methods = []

      doc.method_list.each do |method_doc|
        method = {
          name: method_doc.name,
          description: clean_description(doc.full_name, method_doc.description),
          object_constant: doc.full_name,
          method_type: "#{method_doc.type}_method",
          source_location: "#{@release.version}:#{method_path(method_doc)}:#{method_doc.line}",
          alias: {
            path: clean_path(method_doc.is_alias_for&.path, constant: doc.full_name),
            name: method_doc.is_alias_for&.name
          },
          call_sequence: call_sequence_for_method_doc(method_doc),
          source_body: format_method_source_body(method_doc),
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
        constants: doc.constants.each_with_object([]) { |c, arr| arr << {name: c.name, description: clean_description(doc.full_name, c.description)} },
        attributes: doc.attributes.each_with_object([]) { |a, arr| arr << {name: a.name, description: clean_description(doc.full_name, a.description), access: readwrite_string(a.rw)} },
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

  def clean_path(path, constant:)
    return nil unless path.present?
    PathCleaner.clean(URI(path), constant: constant, version: @version)
  end

  def call_sequence_for_method_doc(doc)
    if doc.call_seq.present?
      doc.call_seq.strip.split("\n").map { |s| s.gsub "->", "→" }
    elsif doc.arglists.present? && doc.arglists != "#{doc.name}()"
      [doc.arglists.strip]
    else
      [doc.name]
    end
  end

  def format_method_source_body(method_doc)
    method_src = CGI.unescapeHTML(ActionView::Base.full_sanitizer.sanitize(method_doc.markup_code))

    lexer = begin
      if method_doc.token_stream&.any? { |t| t.class.to_s == "RDoc::Parser::RipperStateLex::Token" }
        Rouge::Lexers::Ruby.new
      else
        Rouge::Lexers::C.new
      end
    end

    html_formatter = Rouge::Formatters::HTML.new
    formatter = Rouge::Formatters::HTMLLinewise.new(html_formatter, class: "line")

    formatter.format(lexer.lex(method_src))
  end

  def readwrite_string(symbol)
    case symbol
    when "R"
      "read"
    when "W"
      "write"
    when "RW"
      "read/write"
    end
  end
end
