# frozen_string_literal: true

class RubyVersion
  attr_accessor :version, :sha512, :url
  def initialize(version, sha512: nil, url: nil)
    if version == "master"
      @version = "master"
      return
    end

    raise ArgumentError unless Gem::Version.correct?(version)

    @version = Gem::Version.new(version)
    @sha512 = sha512
    @url = url
  end

  def minor_release
    return "master" if master?
    version.segments[0..1].join(".")
  end

  def prerelease?
    return false if master?
    version.prerelease?
  end

  def master?
    version == "master"
  end
end
