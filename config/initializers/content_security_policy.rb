# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
   policy.default_src :self
   policy.img_src     :self
   policy.object_src  :none
   policy.script_src  :self, :unsafe_inline, "https://plausible.io"
   policy.style_src   :self, :unsafe_inline
   policy.connect_src "https://plausible.io"

#   # Specify URI for violation reports
#   # policy.report_uri "/csp-violation-report-endpoint"

   if Rails.env.development?
     policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035"
     policy.style_src   :self, :blob, :unsafe_inline
     policy.script_src  :self, :blob, :unsafe_inline, "https://plausible.io"
   end
end

# If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true


