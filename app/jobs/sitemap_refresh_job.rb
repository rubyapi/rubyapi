# frozen_string_literal: true

class SitemapRefreshJob < ApplicationJob
  queue_as :default

  def perform
    SitemapGenerator::Interpreter.run(
      config_file: Rails.root.join("config/sitemap.rb").to_s,
      verbose: false
    )
  end
end
