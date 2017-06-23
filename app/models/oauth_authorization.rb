class OauthAuthorization < ApplicationRecord
  belongs_to :user, optional: true

  def self.find_or_create(oauth_hash)
    find_or_create_by auth_fields_from(oauth_hash)
  end

  def self.auth_fields_from(hash)
    { provider: hash.provider, uid: hash.uid }
  end
end
