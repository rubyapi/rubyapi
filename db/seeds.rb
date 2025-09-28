# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


versions = RubyConfig.versions.map do |v|
  {
    version: v[:version].to_s,
    url: v[:url],
    sha256: v[:sha256] || "",
    default: v[:default] || false,
    eol: v[:eol] || false,
    prerelease: v[:prerelease] || false,
    git_tag: v[:git][:tag] || "",
    git_branch: v[:git][:branch] || "",
    signatures: v[:signatures] || false
  }
end

RubyRelease.upsert_all(versions, unique_by: :version)
