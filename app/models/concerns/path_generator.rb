module PathGenerator
  extend ActiveSupport::Concern

  included do
    validates :path, presence: true
    before_validation :generate_path
  end

  def generate_path
    self.path = constant&.downcase&.gsub(/\:\:/, "/")
  end
end
