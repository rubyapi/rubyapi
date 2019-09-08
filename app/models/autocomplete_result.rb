# frozen_string_literal: true

class AutocompleteResult
  include SearchHelper

  attr_reader :result, :version

  def initialize(result, version:)
    @result = result
    @version = version
  end

  def autocomplete
    @result.autocomplete
  end

  def path
    result_url result, version: version
  end
end

