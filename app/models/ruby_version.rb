# frozen_string_literal: true

class RubyVersion < Dry::Struct
  attribute :version, Types::String
  attribute :url, Types::String
  attribute :sha256, Types::String
  attribute :git, Types::Hash.default({}.freeze) # Git repository information

  attribute :default, Types::Bool.default(false) # The latest stable version of Ruby
  attribute :eol, Types::Bool.default(false) # Versions of Ruby that have reached end-of-life
  attribute :prerelease, Types::Bool.default(false) # Versions of Ruby that are not yet released

  alias_method :default?, :default
  alias_method :eol?, :eol

  def initialize(attributes = {})
    raise ArgumentError, "version is required" unless attributes[:version].present?

    if attributes[:version] == "dev"
      @_version = "dev"
    else
      raise ArgumentError, "version must be valid" unless Gem::Version.correct?(attributes[:version])
      @_version = Gem::Version.new(attributes[:version])
    end

    super
  end

  def prerelease?
    dev? || prerelease
  end

  def git_ref
    git_tag.presence || git_branch
  end

  def git_branch
    git[:branch]
  end

  def git_tag
    git[:tag]
  end

  def dev?
    version == "dev"
  end

  def has_type_signatures?
    @_version >= "3.0" || dev?
  end

  def to_s
    version
  end
end
