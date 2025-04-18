require "test_helper"

class IndexRubyGemJobTest < ActiveJob::TestCase
  setup do
    WebMock.enable!
  end

  teardown do
    WebMock.disable!
  end

  test "populates the gem metadata from rubygems.org" do
    rubygem = ruby_gem(:rdoc)
    rubygem.update(downloads: 0, latest_version: nil, yanked: false)

    VCR.use_cassette("rubygem_metadata") do
      IndexRubyGemJob.perform_now({ "id" => rubygem.id, "name" => rubygem.name })
    end

    rubygem.reload

    assert_not_nil rubygem.latest_version
    assert_operator rubygem.downloads, :>, 0
    assert_not rubygem.yanked
  end

  test "populates the version metadata from rubygems.org" do
    rubygem = ruby_gem(:rdoc)

    VCR.use_cassette("rubygem_version_metadata") do
      IndexRubyGemJob.perform_now({ "id" => rubygem.id, "name" => rubygem.name })
    end

    rubygem.reload

    assert_not_nil rubygem.latest
    assert_operator rubygem.ruby_gem_versions.size, :>, 0
  end
end
