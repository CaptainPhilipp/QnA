module OmniauthMacros
  def mock_auth_twitter
    OmniAuth.config.mock_auth[:twitter] = {
      provider:  'twitter',
      uid: '123545',
      info: {
        email: 'example@example.com',
      }
    }
  end

  def mock_auth_facebook
    OmniAuth.config.mock_auth[:facebook] = {
      provider:  'facebook',
      uid: '123545',
      info: {
        email: 'example@example.com',
      }
    }
  end

  def mock_auth_without_email
    OmniAuth.config.mock_auth[:twitter] = {
      provider:  'twitter',
      uid: '123545',
      info: {}
    }
  end
end