class CatalogueRubygemsJob < ApplicationJob
  queue_as :default

  RUBYGEMS_ORG_COMPACT_INDEX_CATALOGUE_URL = "https://rubygems.org/names"

  discard_on HTTP::ResponseError

  def perform
    result = RubyGem.upsert_all(build_catalogue, unique_by: :name, returning: [:id, :name])
    jobs = result.map { IndexRubyGemJob.perform_later(it) }
    ActiveJob.perform_all_later(jobs)
  end

  private

  def build_catalogue
    names.split("\n").filter_map do |line|
      case line
      in "---" then nil
      else { name: line }
      end
    end
  end

  def names
    @names ||= fetch_rubygem_names
  end

  def fetch_rubygem_names
    response = HTTP.get(RUBYGEMS_ORG_COMPACT_INDEX_CATALOGUE_URL)
    if response.status.success?
     response.body.to_s
    else
      raise HTTP::ResponseError, "Failed to fetch RubyGems names: #{response.status}"
    end
  end
end
