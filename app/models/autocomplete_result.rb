# frozen_string_literal: true

class AutocompleteResult
  include SearchHelper

  attr_reader :result, :release

  def initialize(result, release:)
    @result = result
    @release = release
  end

  def autocomplete
    @result.autocomplete
  end

  def path
    result_url result, release: release
  end

  def to_hash
    {
      text: autocomplete,
      path: path
    }
  end
end
