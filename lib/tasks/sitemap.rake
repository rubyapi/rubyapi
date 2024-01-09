# frozen_string_literal: true

namespace :sitemap do
  task generate: :environment do
    include Rails.application.routes.url_helpers

    SitemapGenerator::Sitemap.default_host = "https://rubyapi.org"

    if Rails.env.production?
      SitemapGenerator::Sitemap.sitemaps_host = "https://#{SitemapConfig.bucket_name}.s3.amazonaws.com/"
      SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
        options: {
          credentials: AwsConfig.credentials
        }
      )
    end

    SitemapGenerator::Sitemap.create! do
      add "/", changefreq: "never"

      RubyConfig.ruby_versions.each do |version|
        repo = RubyObjectRepository.repository_for_version(version.version)
        response = repo.search(query: {match_all: {}}, size: 10_000)

        response.results.each do |o|
          priority = Ruby::CORE_CLASSES.include?(o.constant) ? 0.5 : 0.9
          add object_path(version:, object: o.path), changefreq: "monthly", priority:
        end
      end
    end
  end
end
