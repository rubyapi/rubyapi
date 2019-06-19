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

  # manually trigger the indexing of models
  Searchkick.disable_callbacks

  def initialize(store, options)
    @store = store
    @options = options
    @full_version = options.generator_options.pop
    @version = Gem::Version.new(@full_version).segments[0..1].join(".")
    @documentation = store.all_classes_and_modules.uniq(&:full_name)
  end

  def generate
    RubyMethod.where(version: @version).destroy_all
    RubyObject.where(version: @version).destroy_all

    skip_namespace = Regexp.union(SKIP_NAMESPACES)

    @documentation.each do |object_rdoc|
      next unless skip_namespace.match(object_rdoc.full_name).nil?

      obj = RubyObject.new(
        name: object_rdoc.name,
        constant: object_rdoc.full_name,
        description: object_rdoc.description,
        object_type: "#{object_rdoc.type}_object".to_sym,
        version: @version
      )

      methods = []

      object_rdoc.method_list.each do |method|
        next if methods.find { |m| m.name == method.name }

        base_ruby_dir = Pathname.new @options.files.first
        method_file = Pathname.new Rails.root.join(method.file.relative_name)

        source_location = method_file.relative_path_from(base_ruby_dir).to_s

        method_doc = RubyMethod.new(
          name: method.name,
          description: method.description,
          method_type: "#{method.type}_method".to_sym,
          version: @version,
          source_location: "#{@full_version}:#{source_location}:#{method.line}"
        )

        if method.call_seq
          method_doc[:call_sequence] = method.call_seq.strip.split("\n").map { |seq|
            seq.gsub "->", "→"
          }
        end

        methods << method_doc
      end

      obj.ruby_methods = methods

      obj.save!
    end

    Searchkick.models.each { |m| m.reindex }
  end
end
