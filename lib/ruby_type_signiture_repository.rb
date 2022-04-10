require "rbs"

class RubyTypeSignitureRepository
  STDLIB_PATH = "stdlib"
  CORE_PATH = "core"
  RUBY_SRC_GEMS_FOLDER = "gems"

  def initialize(ruby_src_dir)
    @ruby_dir = Pathname(ruby_src_dir)
    init_rbs_environment
  end

  def signiture_for_object_instance_method(object:, method:)
    rbs_type_for_object(object) do |object_type|
      return lookup_type_method_signiture(object_type, method, method_type: :instance)
    end
  end

  def signiture_for_object_class_method(object:, method:)
    rbs_type_for_object(object) do |object_type|
      return lookup_type_method_signiture(object_type, method, method_type: :class)
    end
  end

  private

  def rbs_type_for_object(klass, &block)
    type = RBS::TypeName.new(name: klass.to_sym, namespace: RBS::Namespace.root)
    yield type if block_given?
    type
  end

  def lookup_type_method_signiture(type, method, method_type:)
    case method_type.to_sym
    when :instance
      method_definition_for_context(@builder.build_instance(type), method)
    when :class
      method_definition_for_context(@builder.build_singleton(type), method)
    else
      nil
    end
  rescue RuntimeError => e
    return nil
  end

  def init_rbs_environment
    @loader = RBS::EnvironmentLoader.new(core_root: rbs_gem_path.join(CORE_PATH))
    repository.gems.keys.each { |lib| @loader.add library: lib }

    @environment = RBS::Environment.from_loader(@loader).resolve_type_names
    @builder = RBS::DefinitionBuilder.new(env: @environment)
  end

  def method_definition_for_context(context, method)
    context.methods[method.to_sym]&.method_types
  rescue RuntimeError => e
    return nil if e.message =~ /unknown name/
    raise
  end

  def repository
    @repository ||= RBS::Repository.new(no_stdlib: true).tap do |r|
      r.add(rbs_gem_path.join("stdlib"))
    end
  end

  def rbs_gem_path
    @rbs_path ||= Pathname(Dir.glob("#{@ruby_dir.join(RUBY_SRC_GEMS_FOLDER)}/rbs-*").find { |f| Pathname(f).directory? })
  end
end
