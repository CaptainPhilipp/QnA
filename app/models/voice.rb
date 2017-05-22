class Voice < ApplicationRecord
  belongs_to :user
  belongs_to :rateable, polymorphic: true

  validates :value, numericality: { greater_than_or_equal_to: -1, less_than_or_equal_to: 1 }
end
