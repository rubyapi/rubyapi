class RubyGemImport < ApplicationRecord
  enum :status, [ :pending, :processing, :completed, :failed ]

  belongs_to :ruby_gem_version

  validates :status, presence: true

  def retry!
    if retries < 3
      update(status: :pending, retries: retries + 1)
    else
      update(status: :failed)
    end
  end
end
