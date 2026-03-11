return if Rails.env.development? || Rails.env.test?

require "datadog"

Datadog.configure do |c|
  c.service = "rubyapi.org"
  c.env = ENV.fetch("DD_ENV", "production")

  c.tracing.enabled = true
  c.tracing.log_injection = true
  c.runtime_metrics.enabled = true
end
