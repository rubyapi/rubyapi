require "test_helper"

class CatalogueRubygemsJobTest < ActiveJob::TestCase
  setup do
    WebMock.enable!

    WebMock.stub_request(:get, "https://rubygems.org/names")
      .to_return(status: 200, body: "---\ntest-1\ntest-2\n", headers: { "Content-Type" => "text/plain" })
  end

  teardown do
    WebMock.disable!
  end

  test "creates a new RubyGem for each name entry" do
    CatalogueRubygemsJob.perform_now
    assert_equal 2, RubyGem.where(name: ["test-1", "test-2"]).count
  end

  test "queue IndexRubyGemJob for each new RubyGem" do
    CatalogueRubygemsJob.perform_now

    test_gem_1 = RubyGem.find_by(name: "test-1")
    test_gem_2 = RubyGem.find_by(name: "test-2")

    assert_enqueued_with job: IndexRubyGemJob, args: [{ "id" => test_gem_1.id, "name" => test_gem_1.name }]
    assert_enqueued_with job: IndexRubyGemJob, args: [{ "id" => test_gem_2.id, "name" => test_gem_2.name }]
  end

  test "handless HTTP errors gracefully" do
    WebMock.stub_request(:get, "https://rubygems.org/names")
      .to_return(status: 500, body: "Internal Server Error", headers: { "Content-Type" => "text/plain" })

    CatalogueRubygemsJob.perform_now

    assert_equal 0, RubyGem.where(name: ["test-1", "test-2"]).count
    assert_enqueued_jobs 0
  end
end
