require "test_helper"

class AwsConfigTest < ActiveSupport::TestCase
  include Anyway::Testing::Helpers

  test "with static aws credentials" do
    with_env(
      "AWS_AUTHENTICATION_PROVIDER" => "static",
      "AWS_ACCESS_KEY_ID" => "<access_key_id>",
      "AWS_SECRET_ACCESS_KEY" => "<secret_access_key>",
      "AWS_REGION" => "<region>",
      "AWS_SESSION_TOKEN" => "<session_token>"
    ) do
      credentials = AwsConfig.new.credentials
      assert_kind_of Aws::Credentials, credentials
      assert_equal "<access_key_id>", credentials.access_key_id
      assert_equal "<secret_access_key>", credentials.secret_access_key
      assert_equal "<session_token>", credentials.session_token
    end
  end

  test "with ecs aws credential provider" do
    with_env(
      "AWS_AUTHENTICATION_PROVIDER" => "ecs"
    ) do
      capture_subprocess_io do
        credentials = AwsConfig.new.credentials
        assert_kind_of Aws::Credentials, credentials
      end
    end
  end
end
