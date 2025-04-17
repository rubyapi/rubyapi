require "rubygems/dependency"
require "rubygems/spec_fetcher"
require "rubygems/package"

class RubyGemDownloader
  RUBYGEMS_DOWNLOAD_DIR = Rails.root.join("tmp/rubygems").freeze

  attr_reader :rubygem_version

  class_attribute :prefix

  def self.download(rubygem_version)
    new(rubygem_version).tap(&:download)
  end

  def initialize(rubygem_version)
    @rubygem_version = rubygem_version
  end

  def download_path
    RUBYGEMS_DOWNLOAD_DIR.join(prefix.to_s, @rubygem_version.slug)
  end

  def download
    FileUtils.mkdir_p(download_path)
    FileUtils.cd(download_path) do
      fetch_and_unpack_rubygem
    end
  end

  private

  def fetch_and_unpack_rubygem
    dependency = Gem::Dependency.new(@rubygem_version.ruby_gem.name, @rubygem_version.version)
    specs_and_sources, errors = Gem::SpecFetcher.fetcher.spec_for_dependency(dependency)
    spec, source = specs_and_sources.max_by { |spec, _source| spec }

    source.download(spec)

    rubygem_download_path = download_path.join("#{@rubygem_version.slug}.gem").to_s
    verify_downloaded_rubygem_hash!(rubygem_download_path)

    package = Gem::Package.new(rubygem_download_path)
    package.extract_files(download_path)
  end

  def verify_downloaded_rubygem_hash!(downloaded_gem_path)
    gem_file_hash = Digest::SHA256.file(downloaded_gem_path).hexdigest
    if gem_file_hash != @rubygem_version.sha256
      raise "SHA256 hash mismatch for #{@rubygem_version.slug} gem file"
    end
  end
end
