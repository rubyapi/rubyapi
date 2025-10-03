class RubyConstant < ApplicationRecord
  belongs_to :ruby_object

  validates :name, presence: true
  validates :constant, presence: true

  searchkick searchable: [ :name, :description, :constant ],
    word_start: [ :name ],
    word_middle: [ :constant ]

  def search_data
    {
      name: name,
      description: description,
      constant: constant
    }
  end
end
