class StudyRubyRDocGenerator
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
    version = options.generator_options.pop
    @version = Gem::Version.new(version).segments[0..1].join(".")
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

      object_rdoc.method_list.collect do |method|
        next if methods.find { |m| m.name == method.name }

        methods << RubyMethod.new(
          name: method.name,
          description: method.description,
          method_type: "#{method.type}_method".to_sym,
          version: @version
        )
      end

      obj.ruby_methods = methods

      obj.save!
    end

    puts "Indexing Objects and Methods"
    Searchkick.models.each { |m| m.reindex }
  end
end
