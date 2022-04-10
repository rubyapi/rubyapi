# frozen_string_literal: true

class RubyVersion
  attr_accessor :version, :sha512, :source_url

  def initialize(version, sha512: nil, source_url: nil)
    unless version == "dev"
      raise ArgumentError, "invalid version #{version.inspect}" unless Gem::Version.correct?(version)
      @_version = Gem::Version.new(version)
    end

    # RubyGems::Version changes the version string if it has a `-`, we want to keep the original
    @version = version
    @sha512 = sha512
    @source_url = URI(source_url) if source_url.present?
  end

  def minor_version
    return @version if prerelease?
    return "dev" if dev?
    @_version.segments[0..1].join(".")
  end

  def prerelease?
    return true if dev?
    @_version.prerelease?
  end

  def dev?
    @version == "dev"
  end

  def has_type_signitures?
    @version >= "3.0" || dev?
  end
end
