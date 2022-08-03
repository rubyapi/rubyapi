# frozen_string_literal: true

class HeaderComponent < ViewComponent::Base
  def initialize(show_search: false, fixed_nav: true)
    @show_search = show_search
    @fixed_nav = fixed_nav
  end
end
