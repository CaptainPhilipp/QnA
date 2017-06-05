module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :voices, as: :rateable, dependent: :destroy
    has_many :voted_voters, through: :voices
  end

  def rating
    voices.sum(:value)
  end

  def vote!(value, voter)
    value = value.to_i
    value.zero? ? cancel_voice_of(voter) : change_rate_by(voter, value)
  end

  def rated_by?(voter)
    (voice = voice_of voter) && voice.value != 0
  end

  private

  def cancel_voice_of(voter)
    (voice = voice_of(voter)) && voice.update(value: 0)
  end

  def voice_of(voter)
    voices.find_by(user: voter)
  end

  def change_rate_by(voter, amount)
    return if rated_by?(voter)
    return if voter.owner?(self)
    value = amount > 0 ? [amount, 1].min : [amount, -1].max
    voices.create(user: voter, value: value)
  end
end
