# frozen_string_literal: true

class RubyDownloader
  attr_reader :release

  def initialize(release)
    raise ArgumentError unless release.is_a?(RubyVersion)
    @release = release
  end

  def self.download(release)
    new(release).tap(&:download)
  end

  def download
    setup_paths

    if release.dev?
      # Don't cache dev, since it changes frequently
      extracted_download_path.rmtree if extracted_download_path.exist?
    elsif already_fetched?
      puts "Found previously extracted download for " \
        "#{release.version}, skipping"
      return
    end

    fetch_ruby_archive
    prepare_environment
  end

  def rubies_download_path
    Rails.root.join "tmp", "rubies"
  end

  def download_path
    rubies_download_path.join File.basename(release.url)
  end

  def extracted_download_path
    if release.dev?
      rubies_download_path.join "ruby-master"
    else
      rubies_download_path.join File.basename(release.url, ".zip")
    end
  end

  private

  def fetch_ruby_archive
    chunked_fetch download_path, release.url
    verify_file_integrity download_path
  end

  def chunked_fetch(path, url)
    file = File.new path, "wb"
    request = HTTP.get url

    while (chunk = request.readpartial)
      file.write chunk
    end

    file.close
  end

  def gems_path
    extracted_download_path.join("gems")
  end

  def fetch_bundled_gems
    # The cache.ruby-lang.org stable release zips include the .gem files for each bundled gem,
    # but the github master branch .zip does not.
    gems_path.join("bundled_gems")
      .read
      .scan(/(?<name>\w+)\s+(?<version>[\d.]+).*/) do |name, version|
        file_name = "#{name}-#{version}.gem"
        path = gems_path.join(file_name)

        next if path.exist?

        chunked_fetch path, "https://rubygems.org/downloads/#{file_name}"
      end
  end

  def already_fetched?
    File.exist? extracted_download_path.join "README.md"
  end

  def prepare_environment
    system "unzip #{download_path} -d #{rubies_download_path} > #{File::NULL}"
    fetch_bundled_gems
    system "gem unpack --target #{gems_path} #{gems_path.join("rbs-*.gem")}" if release.has_type_signatures?
  end

  def setup_paths
    FileUtils.mkdir(rubies_download_path)
  rescue Errno::EEXIST
  end

  def verify_file_integrity(downloaded_file_path)
    return if release.sha256.empty?

    downloaded_file_hash = Digest::SHA256.file downloaded_file_path
    raise "SHA256 mismatch. Expected #{release.sha256}, but calculated: #{downloaded_file_hash.hexdigest}" \
      unless downloaded_file_hash.hexdigest == release.sha256
  end
end
