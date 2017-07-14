# frozen_string_literal: true

module HasDeltaAssociationUser
  extend ActiveSupport::Concern

  included do
    after_save    :set_user_delta_flag
    after_destroy :set_user_delta_flag
  end

  private

  def set_user_delta_flag
    user.delta = true
    user.save
  end
end
