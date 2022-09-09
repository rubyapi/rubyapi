# frozen_string_literal: true

class HeaderComponent < ViewComponent::Base
  def initialize(current_ruby_version:, show_search: false, fixed_nav: true)
    @current_ruby_version = current_ruby_version
    @show_search = show_search
    @fixed_nav = fixed_nav
  end
end
