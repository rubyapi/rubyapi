# frozen_string_literal: true

require "test_helper"

class PathCleanerTest < ActiveSupport::TestCase
  test "clean relative uris with constant" do
    assert_object_param "fiber", PathCleaner.clean(make_uri("../Fiber"), constant: "Fiber::SchedulerInterface", version: "1.0")
    assert_object_param(
      "rubyvm/abstractsyntaxtree",
      PathCleaner.clean(make_uri("../AbstractSyntaxTree"), constant: "RubyVM::AbstractSyntaxTree::Node", version: "1.0")
    )
  end

  test "clean path full path with nested constant" do
    assert_object_param(
      "thread/queue",
      PathCleaner.clean(make_uri("Thread/Queue"), constant: "Thread::Queue", version: "1.0")
    )
    assert_object_param(
      "csv/row",
      PathCleaner.clean(make_uri("CSV/Row"), constant: "CSV::Row", version: "1.0")
    )
  end

  test "clean path partial path with nested constant" do
    assert_object_param(
      "rubyvm/abstractsyntaxtree/node",
      PathCleaner.clean(make_uri("Node"), constant: "RubyVM::AbstractSyntaxTree::Node", version: "1.0")
    )
  end

  test "clean path with unrelated constant" do
    assert_object_param(
      "enumerator/arithmeticsequence",
      PathCleaner.clean(make_uri("Enumerator/Arithmeticsequence"), constant: "String", version: "1.0")
    )

    assert_object_param(
      "io",
      PathCleaner.clean(make_uri("../IO"), constant: "Fiber::SchedulerInterface", version: "1.0")
    )
  end

  private

  def assert_object_param(expected, uri_string)
    uri = URI(uri_string)
    assert_equal expected, uri.path.split("/")[3..].join("/")
  end

  def make_uri(path)
    URI("#{path}.html")
  end
end
