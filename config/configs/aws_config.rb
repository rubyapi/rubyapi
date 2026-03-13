# fozen_string_literal: true

class AwsConfig < ApplicationConfig
  DEFAULT_AUTHENTICATION_PROVIDER = "static"
  CREDENTIAL_PROVIDERS = %w[static ecs].freeze

  attr_accessor :credentials

  attr_config :authentication_provider
  attr_config :access_key_id, :secret_access_key, :session_token, :region

  on_load :set_credentials

  def set_credentials
    self.credentials = credentials_for_provider(authentication_provider.presence || DEFAULT_AUTHENTICATION_PROVIDER)
  end

  private

  def credentials_for_provider(provider)
    case provider
    when "static"
      Aws::Credentials.new(self.access_key_id, self.secret_access_key, self.session_token)
    when "ecs"
      Aws::ECSCredentials.new(ecs_credential_options).credentials
    else
      raise "Invalid AWS credential provider: #{provider}"
    end
  end

  def ecs_credential_options
    if Rails.env.test?
      { credential_path: "/test/path" }
    else
      {}
    end
  end
end
