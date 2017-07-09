class Subscription < ApplicationRecord
  belongs_to :question

  scope(:instant) { where instant: true }
  scope(:delayed) { where instant: false }
end
