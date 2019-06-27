# frozen_string_literal: true

module Search
  extend ActiveSupport::Concern

  CORE_CLASSES = {
    "String" => 5,
    "Integer" => 5,
    "Float" => 5,
    "Symbol" => 5,
    "Time" => 4,
    "Regex" => 4,
    "Numeric" => 4,
    "Object" => 4,
    "Struct" => 3,
    "Thread" => 2,
    "Signal" => 2,
    "IO" => 2,
  }.freeze

  RESULTS_PER_PAGE = 25

  def search_docs(search_text)
    query = SearchQuery.new(search_text)
    options = search_options(filters: query.filters)

    Searchkick.search(query.terms.join(" ").to_s, options)
  end

  def search_options(filters: {})
    settings = default_search_options
    return settings if filters.empty?

    filters.each do |k, v|
      klass = filter_klass_for(k)
      next unless klass

      settings = klass.filter settings, v
    end

    settings
  end

  def default_search_options
    {
      index_name: [RubyObject, RubyMethod],
      where: {version: ruby_version},
      page: current_page,
      per_page: RESULTS_PER_PAGE,
      fields: ["name^4", "description"], # Favor name of classes, methods over the descriptions
      boost_where: search_boost,
      indices_boost: {RubyMethod => 2, RubyObject => 1}, # Favor methods over objects
    }
  end

  def search_boost
    boosts = {}
    boosts[:method_parent] = ruby_core_object_method_boost
    boosts[:name] = ruby_core_object_boost
    boosts
  end

  # Boost core objets ie: String, Integer
  def ruby_core_object_boost
    CORE_CLASSES.map { |klass, factor| {value: klass, factor: factor} }
  end

  # Boost core object methods, ie: String#to_i, Integer#to_s
  def ruby_core_object_method_boost
    CORE_CLASSES.map { |klass, factor| {value: klass, factor: factor} }
  end

  def filter_klass_for(key)
    case key
    when :in
      SearchFilter::In
    when :is
      SearchFilter::Is
    end
  end
end
