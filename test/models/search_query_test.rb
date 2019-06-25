require "test_helper"

class SearchQueryTest < ActiveSupport::TestCase
  test "original search query" do
    search = SearchQuery.new "hello in:world"
    assert_equal search.query, "hello in:world"
  end

  test "search terms" do
    search = SearchQuery.new "hello is:class world"
    assert_equal search.terms, ["hello", "world"]
  end

  test "search filters" do
    search = SearchQuery.new "hello is:class world has:to_s"
    assert_equal search.filters, { is: "class", has: "to_s" }
  end
end
