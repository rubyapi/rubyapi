# frozen_string_literal: true

require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "show" do
    get page_path(version: "3.4", page: "readme")
    assert_response :success
    assert_select ".ruby-page", /What is Ruby/

    get page_path(version: nil, page: "readme")
    assert_response :success
  end

  test "page not found" do
    get page_path(version: "3.4", page: "invalid")
    assert_response :not_found
  end

  test "different ruby version" do
    ruby_pages(:readme).update!(documentable: ruby_releases(:legacy))

    get page_path page: ruby_pages(:readme).path, version: ruby_releases(:legacy).version
    assert_response :success
  end

  test "page not found on different ruby version" do
    get page_path(version: "2.7", page: "invalid-page")
    assert_response :not_found
  end
end
