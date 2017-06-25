module OmniauthMacros
  AuthHash = Struct.new :provider, :uid, :info

  def mock_auth_twitter
    OmniAuth.config.mock_auth[:twitter] =
      AuthHash.new 'twitter', '23452345', email: 'example@example.com'
  end

  def mock_auth_facebook
    OmniAuth.config.mock_auth[:facebook] =
      AuthHash.new 'facebook', '23452345', email: 'example@example.com'
  end

  def mock_auth_without_email
    OmniAuth.config.mock_auth[:twitter] =
      AuthHash.new 'twitter', '23452345', {}
  end
end
