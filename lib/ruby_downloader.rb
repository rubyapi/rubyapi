class RubyDownloader
  RUBY_HOST = "https://cache.ruby-lang.org/pub/ruby/%{base}/ruby-%{version}.tar.gz".freeze
  RUBY_MASTER_URL = "https://codeload.github.com/ruby/ruby/zip/master"

  attr_reader :version

  def initialize(version)
    @version = version
  end

  def self.download(version)
    downloader = new(version)
    downloader.download
    downloader
  end

  def download
    setup

    if already_fetched?
      puts "Found previously extracted download for " \
        "#{version}, skipping"
      return
    end

    fetch_ruby_archive
    unpack
  end

  def rubies_download_path
    Rails.root.join "tmp", "rubies"
  end

  def download_path
    if master?
      rubies_download_path.join "ruby-master.zip"
    else
      rubies_download_path.join "ruby-#{version}.tar.gz"
    end
  end

  def extracted_download_path
    if master?
      rubies_download_path.join "ruby-master"
    else
      rubies_download_path.join "ruby-#{version}"
    end
  end

  private

  def fetch_ruby_archive
    file = File.new download_path, "wb"
    request = HTTP.get ruby_uri

    while (chunk = request.readpartial)
      file.write chunk
    end

    file.close
  end

  def master?
    version == "master"
  end

  def already_fetched?
    return false if master?
    File.exist? extracted_download_path.join "README.md"
  end

  def unpack
    if master?
      system "unzip #{download_path} -d #{rubies_download_path}"
    else
      system "tar -xf #{download_path} -C #{rubies_download_path}"
    end
  end

  def ruby_uri
    return RUBY_MASTER_URL if master?

    base_version = Gem::Version.new(version).segments[0..1].join(".")
    RUBY_HOST % {base: base_version, version: version}
  end

  def setup
    FileUtils.mkdir(rubies_download_path) unless File.directory?(rubies_download_path)
  end
end
