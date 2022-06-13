require "rbs"

class RubyTypeSignatureRepository
  STDLIB_PATH = "stdlib"
  CORE_PATH = "core"
  RUBY_SRC_GEMS_FOLDER = "gems"

  def initialize(ruby_src_dir)
    @ruby_dir = Pathname(ruby_src_dir)
    init_rbs_environment
  end

  def signiture_for_object_instance_method(object:, method:)
    lookup_type_method_signiture(rbs_type_for_object(object), method, method_type: :instance)
  end

  def signiture_for_object_class_method(object:, method:)
    lookup_type_method_signiture(rbs_type_for_object(object), method, method_type: :class)
  end

  private

  def rbs_type_for_object(klass, &block)
    RBS::TypeName.new(name: klass.to_sym, namespace: RBS::Namespace.root)
  end

  def lookup_type_method_signiture(type, method, method_type:)
    case method_type.to_sym
    when :instance
      method_definition_for_context(@builder.build_instance(type), method)
    when :class
      method_definition_for_context(@builder.build_singleton(type), method)
    end
  rescue RuntimeError
    nil
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
    return nil if /unknown name/.match?(e.message)
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
