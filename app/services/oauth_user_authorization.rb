# find or create Oauth authorization && user
class OauthUserAuthorization
  def initialize(oauth_hash)
    @oauth_hash = oauth_hash
  end

  def call
    user = try_to_find_authorized_user
    return user if user

    find_or_create_user
  end

  private

  attr_reader :oauth_hash

  # most popular request
  def try_to_find_authorized_user
    User.select(:users, :oauth_authorizations)
        .joins(:oauth_authorizations)
        .find_by(oauth_authorizations: oauth_data)
  end

  def oauth_data
    @oauth_data ||= oauth_hash.keep_if { |k, _| %i(provider uid).include? k }
  end

  def find_or_create_user
    user = User.find_by_one_of_args(persisted_auth_args) ||
           User.create_for_oauth(persisted_auth_args)

    user.oauth_authorizations << authorization
    user
  end

  def persisted_auth_args
    @persisted_auth_args ||=
      (oauth_hash.info || {}).keep_if do |_, value|
        User::AUTHORIZATION_FIELDS.includes? value
      end
  end

  def authorization
    @authorization ||= OauthAuthorization.find_or_create_by(oauth_data)
  end
end
