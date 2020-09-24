# frozen_string_literal: true

class RubyVersion
  attr_accessor :version, :sha512, :source_url
  def initialize(version, sha512: nil, source_url: nil)
    if version == "dev"
      @version = "dev"
    else
      raise ArgumentError unless Gem::Version.correct?(version)
      @version = Gem::Version.new(version)
    end

    @sha512 = sha512
    @source_url = URI(source_url) if source_url.present?
  end

  def minor_version
    return "dev" if dev?
    version.segments[0..1].join(".")
  end

  def prerelease?
    return true if dev?
    version.prerelease?
  end

  def dev?
    version == "dev"
  end
end
