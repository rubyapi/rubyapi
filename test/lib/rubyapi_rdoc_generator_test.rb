# frozen_string_literal: true

require "test_helper"

class RubyAPIRDocGeneratorTest < ActiveSupport::TestCase
  test "namespaced superclass association" do
    document "namespaced_superclass.rb"
    object = RubyObject.find_by!(constant: "Namespaced::Child")

    assert_equal "Namespaced::Parent", object.superclass_constant
    assert_equal RubyObject.find_by!(constant: "Namespaced::Parent"), object.superclass
  end

  test "method source location" do
    document "lib/source_location.rb"
    method = RubyMethod.find_by!(constant: "SourceLocation#example")

    assert_equal "2.7:lib/source_location.rb:4", method.source_location
  end

  test ":include: and rdoc-ref: directives" do
    document "directives.rb"
    object = RubyObject.find_by!(constant: "Directives")

    assert_includes object.description, "<p>Included documentation from the source root.</p>"
    assert_includes object.description, '<a href="/2.7/p/language/bsearch">binary search guide</a>'
  end

  test "import pages" do
    document "pages"
    pages = ruby_releases(:legacy).ruby_pages

    copying = pages.find_by!(path: "copying")
    assert_equal "COPYING", copying.name

    bsearch = pages.find_by!(path: "language/bsearch")
    assert_equal "Binary Search", bsearch.name

    bsearch_doc = Nokogiri::HTML.fragment(bsearch.body)
    assert_equal "Binary search finds a value in a sorted collection.", bsearch_doc.at_css("p").text
    assert_empty bsearch_doc.css("h1"), "Expected the title heading to be removed"
    assert bsearch_doc.at_css('[id="binary-search"]'), "Missing title anchor"
    assert bsearch_doc.at_css('[id="label-Binary+Search"]'), "Missing legacy title anchor"
  end

  private

  def document(filename)
    root = Rails.root.join("test/fixtures/doc")
    Dir.chdir(root) do
      opts = RDoc::Options.load_options.tap do |options|
        options.generator = RubyAPIRDocGenerator
        options.generator_options = [ ruby_releases(:legacy) ]
        options.root = root.to_s
        options.files = [ filename ]
        options.op_dir = Rails.root.join("tmp/rdoc_test").to_s
        options.visibility = :private
        options.verbosity = 0
        options.template = ""
      end
      RDoc::RDoc.new.document(opts)
    end
  end
end
