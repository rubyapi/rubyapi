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

  test "show method sequence" do
    object = ruby_objects(:string)
    method = ruby_methods(:to_i)

    method.call_sequence = [
      "to_i -> new_int",
    ]

    object.ruby_methods << method
    object.save

    get object_url object: object.path

    assert_select "div.method__sequence", "to_i -> new_int"
  end

  test "show method name" do
    object = ruby_objects(:string)
    method = ruby_methods(:to_i)

    object.ruby_methods << method
    object.save

    get object_url object: object.path

    assert_select "div.method__sequence", "to_i"
  end
end
