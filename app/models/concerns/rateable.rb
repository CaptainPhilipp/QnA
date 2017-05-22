module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :voices, as: :rateable
    has_many :users, through: :voices
  end

  def rating
    voices.sum(:value)
  end
end
