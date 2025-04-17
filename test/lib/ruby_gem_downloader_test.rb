require "test_helper"

class RubyGemDownloaderTest < ActiveSupport::TestCase
  setup do
    WebMock.enable!

    @rubygem_version = ruby_gem_version(:rails)
    @rubygem_import = ruby_gem_import(:rails)

    VCR.use_cassette("download_rubygem") do
      RubyGemDownloader.download(@rubygem_version)
    end
  end

  teardown do
    FileUtils.rm_rf(RubyGemDownloader::RUBYGEMS_DOWNLOAD_DIR)
    WebMock.disable!
  end

  test "create the folder to download and unpack the gem into" do
    assert File.exist?(RubyGemDownloader::RUBYGEMS_DOWNLOAD_DIR.join("#{@rubygem_version.slug}"))
  end

  test "downloads the correct rubygem from rubygems.org" do
    assert File.exist?(RubyGemDownloader::RUBYGEMS_DOWNLOAD_DIR.join("#{@rubygem_version.slug}/#{@rubygem_version.slug}.gem"))
  end

  test "checks the sha256 hash of the downloaded gem file" do
    @rubygem_version.update(sha256: "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef")

    assert_raises(RuntimeError, "SHA256 hash mismatch for #{@rubygem_version.slug} gem file") do
      RubyGemDownloader.download(@rubygem_version)
    end
  end
end
