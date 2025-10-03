require "application_system_test_case"

class MethodTypeSignatureTest < ApplicationSystemTestCase
  def setup
    @string = ruby_objects(:string)
    @method = ruby_methods(:to_i)
  end

  test "toggle type signatures" do
    visit object_path(object: @string.path)

    click_button "Enable Type Signatures"

    assert_selector :button, text: "Disable Type Signatures"
    assert_selector "h4", text: @method.signatures.first

    click_button "Disable Type Signatures"

    assert_selector :button, text: "Enable Type Signatures"
    assert_selector "h4", text: @method.call_sequences.first
  end
end
