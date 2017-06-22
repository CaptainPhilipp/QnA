class OauthAuthorization < ApplicationRecord
  belongs_to :user, optional: true

  def self.find_or_create(oauth_hash)
    find_or_create_by select_fields_from(oauth_hash)
  end

  def self.select_fields_from(hash)
    { provider: hash.provider, uid: hash.uid }
  end
end
