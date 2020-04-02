# frozen_string_literal: true

class RubyVersion
  attr_accessor :version, :sha512, :url
  def initialize(version, sha512: nil, url: nil)
    if version == "master"
      @version = "master"
    else
      raise ArgumentError unless Gem::Version.correct?(version)
      @version = Gem::Version.new(version)
    end

    @sha512 = sha512
    @url = URI(url)
  end

  def minor_version
    return "master" if master?
    version.segments[0..1].join(".")
  end

  def prerelease?
    return true if master?
    version.prerelease?
  end

  def master?
    version == "master"
  end
end
