# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :ruby_release, :default_ruby_release, :theme, :enable_method_signatures
end
