class IndexRubyGemJob < ApplicationJob
  queue_as :default

  RUBYGEMS_ORG_GEM_URL = "https://rubygems.org/api/v1/gems/%{name}.json"
  RUBYGEMS_ORG_GEM_VERSIONS_URL = "https://rubygems.org/api/v1/versions/%{name}.json"

  def perform(*args)
    @rubygem = RubyGem.find(args.first["id"])

    ActiveRecord::Base.transaction do
      @rubygem.update(rubygem_metadata)

      new_versions = RubyGemVersion.upsert_all(
        index_versions,
        unique_by: [ :ruby_gem_id, :version ],
        returning: [ :id ],
        on_duplicate: { conflict_target: [ :ruby_gem_id, :version ], update: [ :downloads ] }
      )

      jobs = new_versions.map { GenerateRubyGemDocsJob.perform_later(it) }
      ActiveJob.perform_all_later(jobs)
    end
  end

  private

  def rubygem_metadata
    {
      downloads: gem_metadata["downloads"],
      latest_version: gem_metadata["version"],
      yanked: gem_metadata["yanked"]
    }
  end

  def index_versions
    gem_version_metadata.map { rubygem_version_metadata(_1) }
  end

  def rubygem_version_metadata(version_payload)
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

  def gem_metadata
    @gem_metadata ||= query_rubygems_api(RUBYGEMS_ORG_GEM_URL % { name: @rubygem.name })
  end

  def gem_version_metadata
    @version_metadata ||= query_rubygems_api(RUBYGEMS_ORG_GEM_VERSIONS_URL % { name: @rubygem.name })
  end

  def query_rubygems_api(url)
    response = HTTP.get(url)
    if response.status.success?
      response.parse(:json)
    else
      raise HTTP::ResponseError, "Failed to fetch RubyGems names: #{response.status}"
    end
  end
end
