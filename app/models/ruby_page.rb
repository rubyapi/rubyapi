class RubyPage < ApplicationRecord
  belongs_to :ruby_version, optional: true
  belongs_to :ruby_gem_version, optional: true

  validates :name, :body, presence: true
end
