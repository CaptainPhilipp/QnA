# frozen_string_literal: true

class Voice < ApplicationRecord
  belongs_to :user
  belongs_to :rateable, polymorphic: true

  validates :value, numericality: { in: -1..1 }
end
