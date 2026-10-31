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

  SKIP_NAMESPACE_REGEX = /^(#{SKIP_NAMESPACES.join("|")})($|::.+)/

  def class_dir
  end

  def file_dir
  end

  def initialize(store, options)
    @store = store
    @options = options
    @release = options.generator_options.pop
    @documentation = store.all_classes_and_modules

    @page_paths = build_page_paths
  end

  def generate
    generate_pages
    generate_objects
  end

  def generate_pages
    text_files = @store.all_files.select(&:text?)
    text_files.each do |file|
      RubyPage.create!(
        documentable: @release,
        path: @page_paths.fetch(file.path),
        name: file.page_name,
        body: clean_description(file.path, file.description)
      ) do |ruby_page|
        extract_page_name(ruby_page.body) do |name, body|
          ruby_page.name = name
          ruby_page.body = body
        end
      end
    end
  end

  def generate_objects
    objects = []

    if @release.signatures?
      require_relative "ruby_type_signature_repository"
      @type_repository = RubyTypeSignatureRepository.new(@options.root)
    end

    @documentation.each do |doc|
      if skip_namespace? doc.full_name
        ImportUI.warn "Skipping #{doc.full_name}"
        next
      end

      methods = []

      doc.method_list.each do |method_doc|
        method = RubyMethod.new(
          name: method_doc.name,
          description: clean_description(doc.full_name, method_doc.description),
          constant: (method_doc.type == "instance") ? "#{doc.full_name}##{method_doc.name}" : "#{doc.full_name}.#{method_doc.name}",
          method_type: method_doc.type.to_s,
          source_location: "#{@release.version}:#{method_doc.file.relative_name}:#{method_doc.line}",
          call_sequences: call_sequence_for_method_doc(method_doc),
          source_body: format_method_source_body(method_doc),
          metadata: {
            depth: constant_depth(doc.full_name)
          }
        )

        if method_doc.is_alias_for.present?
          method.method_alias = {
            path: clean_path(method_doc.is_alias_for&.path, constant: doc.full_name),
            name: method_doc.is_alias_for&.name
          }
        end

        if @release.signatures?
          signatures = if method_doc.type == "instance"
            @type_repository.signiture_for_object_instance_method(object: doc.name, method: method_doc.name)
          elsif method_doc.type == "class"
            @type_repository.signiture_for_object_class_method(object: doc.name, method: method_doc.name)
          end

          method.signatures = signatures.present? ? signatures.map(&:to_s) : []
        end

        next if methods.any? { |m| m.name == method.name && m.method_type == method.method_type }

        methods << method
      end

      objects << RubyObject.create!(
        documentable: @release,
        name: doc.name,
        path: doc.full_name&.downcase&.gsub("::", "/"),
        description: clean_description(doc.full_name, doc.description),
        constant: doc.full_name,
        object_type: "#{doc.type}_object",
        superclass_constant: superclass_for_doc(doc),
        included_module_constants: doc.includes.map(&:name),
        ruby_methods: methods,
        ruby_constants: doc.constants.map { |c| RubyConstant.new(name: c.name, constant: "#{doc.full_name}::#{c.name}", description: clean_description(doc.full_name, c.description)) },
        ruby_attributes: doc.attributes.map { |a| RubyAttribute.new(name: a.name, description: clean_description(doc.full_name, a.description), access: READWIRTE_MAPPING[a.rw]) },
        metadata: {
          depth: constant_depth(doc.full_name)
        }
      )
    end

    objects
  end

  private

  def build_page_paths # => {"syntax/methods_rdoc.html" => "syntax/methods", **}
    @store.all_files.select(&:text?).each_with_object({}) do |file, h|
      h[file.path] = file.relative_name
        .sub(/\.(?:rdoc|md|txt)\z/i, "")
        .split("/")
        .map { it.tr("_", "-").parameterize }
        .join("/")
    end
  end

  def extract_page_name(body)
    body = Nokogiri::HTML.fragment(body)

    heading = body.at_css("h1, h2")
    return unless heading

    name = heading.text.strip.presence
    return unless name

    # Keep the heading ID as a fragment target.
    if heading["id"]
      anchor = Nokogiri::XML::Node.new("span", body.document)
      anchor["id"] = heading["id"]
      heading.add_previous_sibling(anchor)
    end

    heading.remove
    yield name, body
  end

  def skip_namespace?(constant)
    SKIP_NAMESPACE_REGEX.match?(constant)
  end

  def constant_depth(constant)
    constant.split("::").size
  end

  def clean_description(method_class, description)
    RubyDescriptionCleaner.clean(@release.version, method_class, description, page_paths: @page_paths)
  end

  def clean_path(path, constant:)
    return nil if path.blank?
    PathCleaner.clean(URI(path), constant:, version: @release.version)
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
      doc.superclass.full_name
    end
  end
end
