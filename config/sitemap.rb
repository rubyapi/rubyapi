# frozen_string_literal: true

SitemapGenerator::Sitemap.default_host = "https://rubyapi.org"
SitemapGenerator::Sitemap.public_path = "public"
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/"
SitemapGenerator::Sitemap.compress = true

SitemapGenerator::Sitemap.create(include_root: false) do
  add "/", changefreq: "weekly", priority: 1.0

  RubyRelease.ordered.find_each do |release|
    add versioned_root_path(version: release.version),
      changefreq: "monthly",
      priority: release.default ? 0.9 : 0.7

    RubyObject.where(documentable: release).find_each do |obj|
      core = RubyObject::CORE_CLASSES.key?(obj.constant)
      add object_path(version: release.version, object: obj.path),
        changefreq: "monthly",
        priority: core ? 0.8 : 0.5,
        lastmod: obj.updated_at
    end
  end
end
