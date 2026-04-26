# frozen_string_literal: true

SitemapGenerator::Sitemap.default_host = "https://rubyapi.org"
SitemapGenerator::Sitemap.public_path = "public"
SitemapGenerator::Sitemap.sitemaps_path = ""
SitemapGenerator::Sitemap.compress = true

SitemapGenerator::Sitemap.create(include_root: false) do
  releases = RubyRelease.ordered.where(prerelease: false).where.not(version: "dev").to_a

  group(filename: :core, sitemaps_path: "sitemaps/") do
    add "/", changefreq: nil, priority: nil, lastmod: nil

    releases.each do |release|
      add versioned_root_path(version: release.version),
        changefreq: nil,
        priority: nil,
        lastmod: release.ruby_objects.maximum(:updated_at)
    end
  end

  releases.each do |release|
    next unless release.ruby_objects.exists?

    group(filename: :"ruby-#{release.version}", sitemaps_path: "sitemaps/") do
      release.ruby_objects.find_each do |obj|
        add object_path(version: release.version, object: obj.path),
          changefreq: nil,
          priority: nil,
          lastmod: nil
      end
    end
  end
end
