require "test_helper"

class GenerateRubyGemDocsJobTest < ActiveJob::TestCase
  test "generate docs for a simple gem" do
    rubygem_version = ruby_gem_version(:rake)

    GenerateRubyGemDocsJob.perform_now(rubygem_version.id)

    rubygem_version.reload
    assert rubygem_version.ruby_gem_import.completed?
  end
end
