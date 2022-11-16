# frozen_string_literal: true

Theme = Struct.new(:name, :icon, :default, keyword_init: true) do
  alias_method :default?, :default
end
