class ApplicationHelperTest < ActionView::TestCase
  test "github_url" do
    method = ruby_methods(:to_i)
    assert_equal github_url(method), "https://github.com/ruby/ruby/blob/v2_6_2/foo/bar.c#L123"
  end
end
