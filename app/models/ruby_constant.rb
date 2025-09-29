class RubyConstant < ApplicationRecord
  belongs_to :ruby_object

  validates :name, presence: true
  validates :constant, presence: true
end
