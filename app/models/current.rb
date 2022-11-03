# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :ruby_version, :default_ruby_version
end
