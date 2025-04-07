class IndexRubyGemJob < ApplicationJob
  queue_as :default

  RUBYGEMS_ORG_API_URL = "https://rubygems.org/api/v1/gems/%{name}.json"

  def perform(*args)
    @rubygem = args.first
    @rubygem.update(rubygem_metadata)
  end

  private

  def rubygem_metadata
    {
      name: @rubygem.name,
      latest_version: payload["version"],
      description: payload["description"],
      authors: payload["authors"],
      downloads: payload["downloads"],
      metadata: payload["metadata"],
      dependencies: payload["dependencies"],
    }
  end

  def payload
    @payload ||= fetch_gem_metadata
  end

  def fetch_gem_metadata
    response = HTTP.get(RUBYGEMS_ORG_API_URL % { name: @rubygem.name })
    if response.status.success?
      response.parse(:json)
    else
      raise HTTP::ResponseError, "Failed to fetch RubyGems names: #{response.status}"
    end
  end
end
