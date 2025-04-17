# frozen_string_literal: true

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

  SKIP_NAMESPACE_REGEX = /^(#{SKIP_NAMESPACES.join("|")})($|::.+)/

  def class_dir
  end

  def file_dir
  end

  def rubygem?
    @owner.is_a?(RubyGemVersion)
  end

  def ruby?
    @owner.is_a?(RubyVersion)
  end

  def initialize(store, options)
    @store = store
    @options = options
    @owner = options.generator_options.pop
    @documentation = store.all_classes_and_modules
  end

  def generate
    objects = []

    @documentation.each do |doc|
      if ruby? && skip_namespace?(doc.full_name)
        Rails.logger.warn "Skipping #{doc.full_name}"
        next
      end

      methods = []

      doc.method_list.each do |method_doc|
        type_identifier = case method_doc.type
        in "class" then "."
        in "instance" then "#"
        end

        method = RubyMethod.new(
          name: method_doc.name,
          description: clean_description(doc.full_name, method_doc.description),
          method_type: "#{method_doc.type}_method",
          constant: [ doc.full_name, type_identifier, method_doc.name ].join,
          source_location: ruby? ? "#{@release.version}:#{method_path(method_doc)}:#{method_doc.line}" : "#{method_path(method_doc)}:#{method_doc.line}",
          method_alias: method_doc.is_alias_for&.name,
          call_sequences: call_sequence_for_method_doc(method_doc),
          source_body: format_method_source_body(method_doc),
          metadata: {
            depth: constant_depth(doc.full_name)
          }
        )

        next if methods.any? { |m| m.name == method.name && m.method_type == method.method_type }

        methods << method
      end

      objects << RubyObject.create!(
        ruby_version: ruby? ? @owner : nil,
        ruby_gem_version: rubygem? ? @owner : nil,
        name: doc.name,
        path: doc.full_name.downcase.gsub("::", "/"),
        description: clean_description(doc.full_name, doc.description),
        constant: doc.full_name,
        object_type: "#{doc.type}_object",
        superclass: superclass_for_doc(doc)&.downcase&.gsub("::", "/"),
        included_modules: doc.includes.map { |it| it.name.downcase.gsub("::", "/") },
        ruby_methods: methods,
        ruby_constants: doc.constants.map { |constant| RubyConstant.new(name: constant.name, description: clean_description(doc.full_name, constant.description), constant: [ doc.full_name, "::", constant.name ]) },
        ruby_attributes: doc.attributes.map { |attribute| RubyAttribute.new(name: attribute.name, description: clean_description(doc.full_name, attribute.description), access: READWIRTE_MAPPING[attribute.rw]) },
        metadata: {
          depth: constant_depth(doc.full_name)
        }
      )
    end

    objects
  end

  private

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
    return nil if path.blank?
    PathCleaner.clean(URI(path), constant:, version: @version)
  end

  def call_sequence_for_method_doc(doc)
    if doc.call_seq.present?
      doc.call_seq.strip.split("\n").map { |s| s.gsub "->", "→" }
    elsif doc.arglists.present? && doc.arglists != "#{doc.name}()"
      [ doc.arglists.strip ]
    else
      [ doc.name ]
    end
  end

  def format_method_source_body(method_doc)
    method_src = CGI.unescapeHTML(ActionView::Base.full_sanitizer.sanitize(method_doc.markup_code))

    lexer = if method_doc.token_stream&.any? { |t| t.instance_of?(::RDoc::Parser::RipperStateLex::Token) }
      Rouge::Lexers::Ruby.new
    else
      Rouge::Lexers::C.new
    end

    html_formatter = Rouge::Formatters::HTML.new
    formatter = Rouge::Formatters::HTMLLinewise.new(html_formatter, class: "line")

    formatter.format(lexer.lex(method_src))
  end

  def superclass_for_doc(doc)
    return unless doc.type == "class"
    return if doc.superclass.blank?

    if doc.superclass.is_a?(String)
      doc.superclass
    else
      doc.superclass.name
    end
  end
end
