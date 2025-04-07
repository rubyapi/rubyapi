require "test_helper"

class CatalogueRubygemsJobTest < ActiveJob::TestCase
  setup do
    WebMock.enable!

    WebMock.stub_request(:get, "https://rubygems.org/names")
      .to_return(status: 200, body: "---\nrails\nrake\n", headers: { "Content-Type" => "text/plain" })
  end

  teardown do
    WebMock.disable!
  end

  test "creates a new RubyGem for each name entry" do
    CatalogueRubygemsJob.perform_now
    assert_equal 2, RubyGem.where(name: ["rails", "rake"]).count
  end

  test "queue IndexRubygemJob for each new RubyGem" do
    CatalogueRubygemsJob.perform_now

    rails_gem = RubyGem.find_by(name: "rails")
    rake_gem = RubyGem.find_by(name: "rake")

    assert_enqueued_with job: IndexRubygemJob, args: [{ "id" => rails_gem.id, "name" => rails_gem.name }]
    assert_enqueued_with job: IndexRubygemJob, args: [{ "id" => rake_gem.id, "name" => rake_gem.name }]
  end

  test "handless HTTP errors gracefully" do
    WebMock.stub_request(:get, "https://rubygems.org/names")
      .to_return(status: 500, body: "Internal Server Error", headers: { "Content-Type" => "text/plain" })

    CatalogueRubygemsJob.perform_now

    assert_equal 0, RubyGem.count
    assert_enqueued_jobs 0
  end
end
