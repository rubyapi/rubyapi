# frozen_string_literal: true

require "test_helper"

class LogoComponentTest < ViewComponent::TestCase
  test "render link for current default release" do
    render_preview(:default)

    assert_link "", href: "/"
  end

  test "render link for non-default release" do 
    render_preview(:default, params: { release: ruby_releases(:legacy) })

    assert_link "", href: "/2.7"
  end
end
