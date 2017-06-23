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
    user = find_user_by_info || create_user_without_pass
    user.oauth_authorizations << find_or_create_authorization
    user
  end

  def find_user_by_info
    User.find_by_any(oauth_hash.info || {})
  end

  def create_user_without_pass
    info = User.select_fillabe_fields(oauth_hash.info || {})
    User.create_without_pass(info)
  end

  def find_or_create_authorization
    OauthAuthorization.find_or_create(oauth_hash)
  end
end
