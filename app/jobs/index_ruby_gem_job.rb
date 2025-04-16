class IndexRubyGemJob < ApplicationJob
  queue_as :default

  RUBYGEMS_ORG_API_URL = "https://rubygems.org/api/v1/versions/%{name}.json"

  def perform(*args)
    @rubygem = RubyGem.find(args.first["id"])

    RubyGemVersion.upsert_all(
      index_versions,
      unique_by: [ :ruby_gem_id, :version ],
      returning: [ :id ],
      on_duplicate: { conflict_target: [ :ruby_gem_id, :version ], update: [ :downloads ] }
    )
  end

  private

  def index_versions
    payload.map { rubygem_metadata(_1) }
  end

  def rubygem_metadata(version_payload)
    {
      ruby_gem_id: @rubygem.id,
      version: version_payload["number"],
      summary: version_payload["summary"],
      description: version_payload["description"],
      downloads: version_payload["downloads_count"],
      metadata: version_payload["metadata"],
      authors: version_payload["authors"],
      prerelease: version_payload["prerelease"],
      licenses: version_payload["licenses"],
      sha256: version_payload["sha"],
      published_at: version_payload["created_at"],
      built_at: version_payload["built_at"]
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
