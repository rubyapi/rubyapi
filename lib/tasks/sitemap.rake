# frozen_string_literal: true

namespace :sitemap do
  task generate: :environment do
    include Rails.application.routes.url_helpers

    SitemapGenerator::Sitemap.default_host = "https://rubyapi.org"

    if Rails.env.production?
      require "aws-sdk-s3"

      SitemapGenerator::Sitemap.sitemaps_host = "https://#{ENV["AWS_BUCKET_NAME"]}.s3.amazonaws.com/"
      SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
        ENV["AWS_BUCKET_NAME"],
        aws_access_key_id: ENV["AWS_KEY_ID"],
        aws_secret_access_key: ENV["AWS_KEY_SECRET"],
        aws_region: ENV["AWS_REGION"]
      )
    end

    SitemapGenerator::Sitemap.create do
      add "/", changefreq: "never"

      Rails.configuration.ruby_versions.each do |version|
        repo = RubyObjectRepository.repository_for_version(version)
        response = repo.search(query: {match_all: {}}, size: 10_000)

        response.results.each do |o|
          priority = Ruby::CORE_CLASSES.include?(o.constant) ? 0.5 : 0.9
          add object_path(version: version, object: o.path), changefreq: "monthly", priority: priority
        end
      end
    end
  end
end
