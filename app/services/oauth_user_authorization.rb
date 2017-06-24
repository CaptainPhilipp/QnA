# find or create oauth_authorization and user OR set session
class OauthUserAuthorization

  def initialize(request, session)
    args = request.env['omniauth.auth']
    @session  = session
    @provider = args[:provider]
    @uid      = args[:uid]
    @info     = args[:info] || {}
  end

  def try_get_user
    user = User.find_with_uid(provider: provider, uid: uid)
    return user if user
    user = find_or_create_user
    user.persisted? ? find_or_create_auth.update(user: user) : save_to_session
    user
  end

  def self.from_session(params, session)
    user = User.create_without_pass(params)
    OauthAuthorization.find(session[SESSION_KEY]).update(user: user)
    user
  end

  private

  SESSION_KEY = 'devise.oauth_authorization'

  attr_reader :provider, :uid, :info, :session

  def find_or_create_user
    User.find_by(email: info[:email]) ||
    User.create_without_pass(email: info[:email])
  end

  def find_or_create_auth
    OauthAuthorization.find_or_create_by provider: provider, uid: uid
  end

  def save_to_session
    session[SESSION_KEY] = find_or_create_auth.id
  end
end
