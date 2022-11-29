# frozen_string_literal: true

Theme = Struct.new(:name, :icon, :meta, :default, :dynamic, keyword_init: true) do
  alias_method :default?, :default
  alias_method :dynamic?, :dynamic
end
