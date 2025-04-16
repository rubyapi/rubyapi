# frozen_string_literal: true

class RubyAttribute < ApplicationRecord
  belongs_to :ruby_object

  validates :name, presence: true
end
