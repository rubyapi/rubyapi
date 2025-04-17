require "test_helper"

class RubyGemImportTest < ActiveSupport::TestCase
  test "sets a default status" do
    ruby_gem_import = RubyGemImport.new
    assert_equal "pending", ruby_gem_import.status
  end

  test "retry processing a gem" do
    import = ruby_gem_import(:rails)
    import.retry!

    assert import.pending?
    assert_equal 1, import.retries
  end

  test "when retries reach 3, it fails" do
    import = ruby_gem_import(:rails)
    import.update(retries: 3)
    import.retry!

    assert import.failed?
    assert_equal 3, import.retries
  end
end
