# find or create Oauth authorization && user
class OauthUserAuthorization
  def initialize(oauth_hash)
    @oauth_hash = oauth_hash
  end

  def call
    User.find_for_oauth(oauth_hash) || find_or_create_user
  end

  private

  attr_reader :oauth_hash

  def find_or_create_user
    user = find_user_by_info || create_user_with_info
    user.oauth_authorizations << oauth_authorization
    user
  end
  
  def find_user_by_info
    User.find_by_any(oauth_hash.info || {})
  end
  
  def create_user_with_info
    User.create_without_pass(oauth_hash.info || {})
  end

  def oauth_authorization
    OauthAuthorization.find_or_create(oauth_hash)
  end
end
