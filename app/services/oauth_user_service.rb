# find or create oauth_authorization and user OR set session
class OauthUserService
  def initialize(args)
    @provider = args[:provider]
    @uid      = args[:uid]
    @info     = args[:info] || {}
  end

  def get_user
    user = User.find_with_uid(provider: provider, uid: uid)
    return user if user
    user = find_or_create_user
    find_or_create_auth.update(user: user) if user.valid?
    user
  end

  def save_auth_to(session)
    session[SESSION_KEY] = authentication.id
  end

  def self.auth_user_from(session, params)
    user = User.create_without_pass(params)
    return user unless user.valid?
    OauthAuthorization.find(session[SESSION_KEY]).update(user: user)
    user
  end

  private

  SESSION_KEY = 'devise.oauth_authorization'

  attr_reader :provider, :uid, :info, :session

  def find_or_create_user
    @user ||= User.find_by(email: info[:email]) ||
              User.create_without_pass(email: info[:email])
  end

  def find_or_create_auth
    @auth ||= OauthAuthorization.find_or_create_by provider: provider, uid: uid
  end

  alias authentication find_or_create_auth
end
