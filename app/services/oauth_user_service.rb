# find or create oauth_authorization and user OR set session
class OauthUserService
  def initialize(provider: nil, uid: nil, info: nil)
    @provider = provider
    @uid      = uid
    @info     = info || {}
  end

  def get_user # : User
    user = User.find_with_uid(provider: provider, uid: uid)
    return user if user

    user = find_or_create_user
    get_auth.update(user: user) if user.valid?

    user
  end

  def get_auth # : Auth
    @auth ||= OauthAuthorization.find_or_create_by provider: provider, uid: uid
  end

  def self.create_user_with(oauth_id, params)
    user = User.create_without_pass(params)
    return user unless user.valid?
    OauthAuthorization.find(oauth_id).update(user: user)
    user
  end

  private

  attr_reader :provider, :uid, :info

  def find_or_create_user
    @user ||= User.find_by(email: info[:email]) ||
              User.create_without_pass(email: info[:email])
  end
end
