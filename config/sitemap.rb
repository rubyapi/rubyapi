# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://rubyapi.org"
SitemapGenerator::Sitemap.public_path = "public/sitemaps"

SitemapGenerator::Sitemap.create do
  add "/", changefreq: "never"

  RubyConfig.ruby_versions.each do |version|
    repo = RubyObjectRepository.repository_for_version(version.version)
    response = repo.search(query: {match_all: {}}, size: 10_000)

    response.results.each do |o|
      priority = Ruby::CORE_CLASSES.include?(o.constant) ? 0.5 : 0.9
      add object_path(version:, object: o.path), changefreq: "monthly", priority:
    end
  rescue OpenSearch::Transport::Transport::Errors::NotFound => e
    # Index does not exist
    if Rails.env.local?
      next
    else
      raise e
    end
  end
end
