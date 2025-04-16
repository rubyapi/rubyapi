require "application_system_test_case"

class MethodTypeSignatureTest < ApplicationSystemTestCase
  def setup
    @string = FactoryBot.build(:ruby_object)
    @method = FactoryBot.build(:ruby_method, name: "signature_test_1", signatures: [ "(::String input) -> ::String" ])
    @string.ruby_methods << @method

    create_index_for_version! default_ruby_version
    index_object @string
  end

  test "toggle type signatures" do
    visit object_path(object: @string.path)

    click_button "Enable Type Signatures"

    assert_selector :button, text: "Disable Type Signatures"
    assert_selector "h4", text: @method.signatures.first

    click_button "Disable Type Signatures"

    assert_selector :button, text: "Enable Type Signatures"
    assert_selector "h4", text: @method.call_sequence.first
  end
end
