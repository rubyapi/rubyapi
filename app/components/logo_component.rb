# frozen_string_literal: true

class LogoComponent < ViewComponent::Base
  def initialize(release: Current.ruby_release)
    @release = release
  end

  def home_path
    @release.default? ? root_path : versioned_root_path(version: @release.version)
  end
end
