class Header::VersionSelectorComponentPreview < ViewComponent::Preview
  layout "view_component_testing"
  
  def initialize
    Current.theme = ThemeConfig.theme_for("system")
  end

  def with_latest_version
    latest = RubyRelease.latest
    render(Header::VersionSelectorComponent.new(current_release: latest))
  end
end
