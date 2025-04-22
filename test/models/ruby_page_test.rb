require "test_helper"

class RubyPageTest < ActiveSupport::TestCase
  test "validations" do
    page = RubyPage.new

    assert_not page.valid?
    assert_includes page.errors[:name], "can't be blank"
    assert_includes page.errors[:body], "can't be blank"
  end
end
