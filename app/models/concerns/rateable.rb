module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :voices, as: :rateable, dependent: :destroy
    has_many :voted_users, through: :voices
  end

  def rating
    voices.sum(:value)
  end

  def rated_by?(user)
    voice_of(user) != nil
  end

  def rate_up_by(user)
    change_rate_by(user, 1)
  end

  def rate_down_by(user)
    change_rate_by(user, -1)
  end

  def cancel_voice_of(user)
    (voice = voice_of(user)) && voice.destroy
  end

  private

  def voice_of(user)
    voices.find_by(user: user)
  end

  def change_rate_by(user, amount)
    return if rated_by?(user)
    value = amount > 0 ? [amount, 1].min : [amount, -1].max
    voices.create(user: user, value: value)
  end
end
