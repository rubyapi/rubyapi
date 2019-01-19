require "test_helper"

class ObjectsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    object = ruby_objects(:string)
    object.save!

    get object_url object: object.path
    assert_response :success
  end

  test "object not found" do
    assert_raises ActiveRecord::RecordNotFound do
      get object_url object: "invalid"
    end
  end

  test "different ruby version" do
    object = ruby_objects :string
    object.version = "2.5"
    object.save

    get object_url object: object.path, version: "2.5"
    assert_response :success
  end

  test "object not found on different ruby version" do
    object = ruby_objects :integer
    object.version = "2.3"
    object.save

    assert_raises ActiveRecord::RecordNotFound do
      get object_url object: object.path, version: "2.6"
    end
  end
end
