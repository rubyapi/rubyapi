class Header::SearchComponentPreview < ViewComponent::Preview
  layout "view_component_testing"
  
  def initialize
    Current.theme = ThemeConfig.theme_for("system")
  end

  def with_version(release: RubyRelease.latest)
    render(Header::SearchComponent.new(release: release))
  end
end
