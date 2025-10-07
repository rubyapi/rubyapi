class RubyAttribute < ApplicationRecord
  belongs_to :ruby_object
  validates :name, presence: true

  scope :ordered, -> { order(:name) }
end
