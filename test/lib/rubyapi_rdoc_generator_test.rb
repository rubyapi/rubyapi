# frozen_string_literal: true

require "test_helper"

class RubyAPIRDocGeneratorTest < ActiveSupport::TestCase
  test "namespaced superclass association" do
    document "namespaced_superclass.rb"
    object = RubyObject.find_by!(constant: "Namespaced::Child")

    assert_equal "Namespaced::Parent", object.superclass_constant
    assert_equal RubyObject.find_by!(constant: "Namespaced::Parent"), object.superclass
  end

  test "method alias not duplicating path segments" do
    document "namespaced_method_alias.rb"
    method = RubyMethod.find_by!(constant: "Thread::Queue#shift")

    assert_equal({ "name" => "pop", "path" => "/test/o/thread/queue#method-i-pop" }, method.method_alias)
  end

  private

  def document(filename)
    opts = RDoc::Options.load_options.tap do |options|
      options.generator = RubyAPIRDocGenerator
      options.generator_options = [ RubyRelease.new(version: "test", signatures: false) ]
      options.root = Rails.root.join("test/fixtures/doc").to_s
      options.files = [ Rails.root.join("test/fixtures/doc", filename).to_s ]
      options.op_dir = Rails.root.join("tmp/rdoc_test").to_s
      options.visibility = :private
      options.verbosity = 0
      options.template = ""
    end
    RDoc::RDoc.new.document(opts)
  end
end
