# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data
    policy.object_src  :none
    policy.script_src  :self, :https
    policy.style_src   :self, :https, :unsafe_inline # Needed by Stimulus Reflex
    policy.connect_src :self, :https, "wss://rubyapi.org"
    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"

    if Rails.env.development?
      policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035"
      policy.style_src   :self, :blob, :unsafe_inline
      policy.script_src  :self, :blob, :unsafe_inline
    end
  end
#
#   # Generate session nonces for permitted importmap and inline scripts
#   config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
#   config.content_security_policy_nonce_directives = %w(script-src)
#
#   # Report CSP violations to a specified URI. See:
#   # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
#   # config.content_security_policy_report_only = true
end
