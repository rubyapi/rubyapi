class RubyAPIRDocGenerator
  SKIP_NAMESPACES = [
    /Bundler\:\:.*/,
    /RDoc\:\:.*/,
    /IRB\:\:.*/,
  ].freeze

  def class_dir
  end

  def file_dir
  end

  def initialize(store, options)
    @store = store
    @options = options
    @full_version = options.generator_options.pop
    @version = @full_version == "master" ? "master" : Gem::Version.new(@full_version).segments[0..1].join(".")
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
        next if methods.find { |m| m[:name] == method_doc.name }

        methods << {
          name: method_doc.name,
          description: clean_description(method_doc.description),
          object_constant: doc.full_name,
          method_type: "#{method_doc.type}_method",
          source_location: "#{@full_version}:#{method_path(method_doc)}:#{method_doc.line}",
          call_sequence: method_doc.call_seq ? method_doc.call_seq.strip.split("\n").map { |s| s.gsub "->", "→" } : "",
        }
      end

      objects << RubyObject.new(
        name: doc.name,
        description: clean_description(doc.description),
        methods: methods,
        constant: doc.full_name,
        object_type: "#{doc.type}_object"
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
    !skip_namespace_regex.match(constant).nil?
  end

  def skip_namespace_regex
    Regexp.union(SKIP_NAMESPACES)
  end

  def clean_description(description)
    description
      .gsub(/(\<a.*\&para\;\<\/a>)/, "")
      .gsub(/(\<a.*\&uarr\;\<\/a>)/, "")
      .gsub("<pre class=\"ruby\">", "<div class=\"ruby\" data-controller=\"code-example\" data-target=\"code-example.block\"></div><pre class=\"ruby\">")
  end
end
