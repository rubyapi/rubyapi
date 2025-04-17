require "test_helper"

class IndexRubyGemJobTest < ActiveJob::TestCase
  setup do
    WebMock.enable!
  end

  teardown do
    WebMock.disable!
  end

  test "updates metadata from rubygems.org" do
    rubygem = ruby_gem(:rdoc)

    VCR.use_cassette("rubygem_versions") do
      IndexRubyGemJob.perform_now({ "id" => rubygem.id, "name" => rubygem.name })
    end

    rubygem.reload

    assert_not_nil rubygem.latest
    assert_operator rubygem.ruby_gem_versions.size, :>, 0
  end
end
