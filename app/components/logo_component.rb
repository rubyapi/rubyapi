# frozen_string_literal: true

class LogoComponent < ViewComponent::Base
  def home_path
    return root_path if Current.ruby_version.default?
    versioned_root_path(version: Current.ruby_version)
  end
end
