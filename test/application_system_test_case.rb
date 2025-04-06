# frozen_string_literal: true

require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  options = ENV["DEVCONTAINER_APP_HOST"].present? ? { browser: :remote, url: ENV["SELENIUM_URL"] } : {}
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400], options: options
end

if ENV["DEVCONTAINER_APP_HOST"].present?
  Capybara.always_include_port = true
  Capybara.server_host = "0.0.0.0"
  Capybara.server_port = ENV["CAPYBARA_SERVER_PORT"]&.to_i
  Capybara.app_host = "#{ENV['DEVCONTAINER_APP_HOST']}:#{Capybara.server_port}"
end