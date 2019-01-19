class RubyDownloader
  RUBY_HOST = "https://cache.ruby-lang.org/pub/ruby/%{base}/ruby-%{version}.tar.gz".freeze

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
      puts 'Found previously extracted download for ' \
        "#{version}, skipping"
      return
    end

    fetch_ruby_archive
    unpack
  end

  def rubies_download_path
    Rails.root.join 'tmp', 'rubies'
  end

  def download_path
    rubies_download_path.join "ruby-#{version}.tar.gz"
  end

  def extracted_download_path
    rubies_download_path.join "ruby-#{version}"
  end

  private

  def fetch_ruby_archive
    puts "Downloading Ruby #{version} from #{ruby_uri}"

    file = File.new download_path, 'wb'
    request = HTTP.get ruby_uri

    while chunk = request.readpartial
      file.write chunk
    end

    file.close

    puts "Downloaded #{version} to #{download_path}"
  end

  def already_fetched?
    File.exist? extracted_download_path.join 'README.md'
  end

  def unpack
    system "tar -xf #{download_path} -C #{rubies_download_path}"
  end

  def ruby_uri
    base_version = Gem::Version.new(version).segments[0..1].join('.')
    RUBY_HOST % { base: base_version, version: version }
  end

  def setup
    FileUtils.mkdir(rubies_download_path) unless File.directory?(rubies_download_path)
  end
end
