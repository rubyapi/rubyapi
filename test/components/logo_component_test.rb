# frozen_string_literal: true

require "test_helper"

class LogoComponentTest < ViewComponent::TestCase
  def test_component_renders_root_link
    render_inline(LogoComponent.new)

    assert_component_rendered

    assert_link "", href: "/"
  end

  def test_component_renders_versioned_root_link
    Current.ruby_version = ruby_version(:legacy)

    render_inline(LogoComponent.new)

    assert_component_rendered

    assert_link "", href: "/2.7"
  end
end
