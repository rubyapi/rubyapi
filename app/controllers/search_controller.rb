class SearchController < ApplicationController
  RESULTS_PER_PAGE = 25

  before_action :index, -> { redirect_to root_path unless search_query.present? }

  CORE_CLASSES = {
    "String" => 5,
    "Integer" => 5,
    "Float" => 5,
    "Integer" => 5,
    "Symbol" => 5,
    "Time" => 4,
    "Regex" => 4,
    "Numeric" => 4,
    "Object" => 4,
    "Struct" => 3,
    "Thread" => 3,
    "Thread" => 2,
    "Signal" => 2,
    "IO" => 2,
  }.freeze

  def index
    @search = search_results
  end

  private

  def search_results
    Searchkick.search(
      search_query,
      {
        index_name: [RubyObject, RubyMethod],
        where: {version: ruby_version},
        page: current_page,
        per_page: RESULTS_PER_PAGE,
        fields: ["name^2", "description"], # Favor name of classes, methods over the descriptions
        boost_where: search_boost,
        indices_boost: { RubyMethod => 2, RubyObject => 1 } # Favor methods over objects
      }
    )
  end

  def current_page
    params[:page]
  end

  private

  def search_boost
    boosts = Hash.new
    boosts[:method_parent] = ruby_core_object_method_boost
    boosts[:name] = ruby_core_object_boost
    boosts
  end

  # Boost core objets ie: String, Integer
  def ruby_core_object_boost
    CORE_CLASSES.map { |klass, factor| { value: klass, factor: factor } }
  end

  # Boost core object methods, ie: String#to_i, Integer#to_s
  def ruby_core_object_method_boost
    CORE_CLASSES.map { |klass, factor| { value: klass, factor: factor } }
  end
end
