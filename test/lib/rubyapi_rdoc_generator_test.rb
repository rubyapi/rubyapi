# frozen_string_literal: true

require "test_helper"

class RubyAPIRDocGeneratorTest < ActiveSupport::TestCase
  test "namespaced superclass association" do
    document "namespaced_superclass.rb"
    object = RubyObject.find_by!(constant: "Namespaced::Child")

    assert_equal "Namespaced::Parent", object.superclass_constant
    assert object.superclass
  end

  private

  # Documents files with RubyAPIRDocGenerator.
  #
  #   document "test_class.rb"
  #   assert RubyObject.find_by(constant: "TestClass")
  #
  # Returns an RDoc::RDoc instance.
  #
  #   rdoc = document "test_class.rb"
  #   rdoc.store.all_classes_and_modules
  #
  def document(
    path, # file, dir, glob
    release: RubyRelease.new(version: "test", signatures: false),
    root: "test/fixtures/doc",
    visibility: :private, # :private, :protected
    verbosity: 0 # 0, 1, 2
  )
    opts = RDoc::Options.load_options.tap do |options|
      options.generator = RubyAPIRDocGenerator
      options.generator_options = [ release ]
      options.root = Rails.root.join(root).to_s
      options.files = Rails.root.join(root).glob(path).map(&:to_s)
      options.op_dir = Rails.root.join("tmp/rdoc_test").to_s
      options.visibility = visibility
      options.verbosity = verbosity
      options.template = ""
    end
    RDoc::RDoc.new.tap do |rdoc|
      rdoc.document(opts)
    end
  end
end
