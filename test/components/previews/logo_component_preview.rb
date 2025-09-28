class LogoComponentPreview < ViewComponent::Preview
  layout "view_component_testing"
  
  def initialize
    Current.theme = ThemeConfig.theme_for("system")
  end

  def default(release: RubyRelease.latest)
    render(LogoComponent.new(release: release))
  end
end
