# frozen_string_literal: true

require "csv"

module RubyReleases
  class ReleaseList
    RELEASE_INDEX_URL = "https://cache.ruby-lang.org/pub/ruby/index.txt"
    SUPPORTED_RELEASE_FORMAT = %w[tar.gz]

    def self.fetch
      new.releases
    end

    attr_accessor :releases
    def initialize
      @releases = parse_index(release_index)
    end

    private

    def parse_index(index)
      releases = []

      CSV.parse(index, col_sep: "\t", headers: true).map do |l|
        version = begin
          if l["name"].start_with?("ruby-")
            l["name"].match(/ruby-(.+)/)[1]
          else
            l["name"]
          end
        end

        releases << RubyVersion.new(version, sha512: l["sha512"], url: l["url"]) if supported_release_format?(l["url"])
      rescue ArgumentError
      end

      releases
    end

    def supported_release_format?(url)
      SUPPORTED_RELEASE_FORMAT.any? { |format| url.end_with?(format) }
    end

    def release_index
      HTTP.get(RELEASE_INDEX_URL).body.to_s
    rescue HTTP::Error
      raise "Unable to download the Ruby release index @ #{RELEASE_INDEX_URL}"
    end
  end
end
