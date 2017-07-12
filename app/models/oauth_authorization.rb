# frozen_string_literal: true

class OauthAuthorization < ApplicationRecord
  belongs_to :user, optional: true
end
