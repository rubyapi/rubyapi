# frozen_string_literal: true

require_relative "ruby_description_cleaner"
require "rouge"

class RubyAPIRDocGenerator
  SKIP_NAMESPACES = %w[
    Bundler
    RDoc
    IRB
  ].freeze

  READWIRTE_MAPPING = {
    "R" => "Read",
    "W" => "Write",
    "RW" => "Read & Write"
  }.freeze

  SKIP_NAMESPACE_REGEX = /^(#{SKIP_NAMESPACES.join('|')})($|::.+)/

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
    index generate_objects
  end

  def generate_objects
    objects = []

    if @release.has_type_signatures?
      require_relative "./ruby_type_signature_repository"
      @type_repository = RubyTypeSignatureRepository.new(@options.files.first)
    end

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

        if @release.has_type_signatures?
          signatures = if method_doc.type == "instance"
            @type_repository.signiture_for_object_instance_method(object: doc.name, method: method_doc.name)
          elsif method_doc.type == "class"
            @type_repository.signiture_for_object_class_method(object: doc.name, method: method_doc.name)
          end

          method[:signatures] = signatures.present? ? signatures.map(&:to_s) : []
        end

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
        methods:,
        constant: doc.full_name,
        object_type: "#{doc.type}_object",
        superclass:,
        included_modules: doc.includes.map(&:name),
        constants: doc.constants.map { |c| {name: c.name, description: clean_description(doc.full_name, c.description)} },
        attributes: doc.attributes.map { |a| {name: a.name, description: clean_description(doc.full_name, a.description), access: READWIRTE_MAPPING[a.rw]} },
        metadata: {
          depth: constant_depth(doc.full_name)
        }
      )
    end

    objects
  end

  private

  def index(objects)
    [object_repository, search_repository].each { |repo| repo.bulk_import(objects) }
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
    PathCleaner.clean(URI(path), constant:, version: @version)
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

    lexer = if method_doc.token_stream&.any? { |t| t.class.to_s == "RDoc::Parser::RipperStateLex::Token" }
      Rouge::Lexers::Ruby.new
    else
      Rouge::Lexers::C.new
    end

    html_formatter = Rouge::Formatters::HTML.new
    formatter = Rouge::Formatters::HTMLLinewise.new(html_formatter, class: "line")

    formatter.format(lexer.lex(method_src))
  end
end
