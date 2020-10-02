# frozen_string_literal: true

Rack::Attack.throttle("code execution requests by ip", limit: 5, period: 30) do |req|
  if req.path == '/run' && req.post?
    req.env['HTTP_CF_CONNECTING_IP']
  end
end
