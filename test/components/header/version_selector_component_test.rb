# frozen_string_literal: true

require "test_helper"

class Header::VersionSelectorComponentTest < ViewComponent::TestCase
  def setup
    Current.ruby_release = ruby_releases(:latest)
  end

  test "renders the version selector with current current version" do
    render_preview(:with_latest_version)
    assert_button "3.4"
  end

  test "renders the version selector with all available versions" do
    render_preview(:with_latest_version)
    assert_link "2.7", href: "/2.7"
  end
end
