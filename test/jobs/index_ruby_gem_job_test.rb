require "test_helper"

class IndexRubyGemJobTest < ActiveJob::TestCase
  setup do
    WebMock.enable!
  end

  teardown do
    WebMock.disable!
  end

  test "updates metadata from rubygems.org" do
    rubygem = RubyGem.create(name: "rails")

    VCR.use_cassette("rubygem_metadata") do
      IndexRubyGemJob.perform_now(rubygem)
    end

    rubygem.reload

    assert_equal "8.0.2", rubygem.latest_version
  end
end
