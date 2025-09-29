class RubyPage < ApplicationRecord
  belongs_to :documentable, polymorphic: true

  validates :name, presence: true
end
