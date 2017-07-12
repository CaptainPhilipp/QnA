# frozen_string_literal: true

module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :voices, as: :rateable, dependent: :destroy
    has_many :voters, through: :voices
  end

  def rating
    voices.sum(:value)
  end

  def vote!(value, voter)
    value = value.to_i
    value.zero? ? cancel_voice_of(voter) : change_rate_by(value, voter)
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

  def change_rate_by(amount, voter)
    return if rated_by?(voter)
    return if voter.owner?(self)
    value = amount > 0 ? [amount, 1].min : [amount, -1].max
    create_voice(value, voter)
  end

  def create_voice(value, voter)
    voice = voice_of(voter) || voices.create(user: voter)
    voice.update(user: voter, value: value)
  end
end
