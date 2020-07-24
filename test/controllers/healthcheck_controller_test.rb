# frozen_string_literal: true

require "test_helper"

class HealthcheckControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ping_url
    assert_response :success
  end

  test "should respond with pong" do
    get ping_url
    assert_equal "pong", @response.body
  end
end
