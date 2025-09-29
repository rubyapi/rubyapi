require "test_helper"

class RubyPageTest < ActiveSupport::TestCase
  test "required fields" do
    ruby_page = RubyPage.new
    assert_not ruby_page.valid?
    assert_includes ruby_page.errors[:name], "can't be blank"
  end
end
