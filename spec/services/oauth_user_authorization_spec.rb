require 'rails_helper'

RSpec.describe OauthUserAuthorization do
  let(:email)     { 'example@example.com' }
  let(:provider)  { 'facebook' }
  let(:uid)       { '12341234' }

  let(:user)      { create :user, email: email }
  let(:auth_hash) { OmniAuth::AuthHash.new provider: provider, uid: uid }

  it 'should return User object' do
    expect(OauthUserAuthorization.new(auth_hash).call).to be_a User
  end

  context 'when user exists' do
    context 'and authentication exist' do
      let!(:authentication) { create :omniauth_authentication, provider: provider, uid: uid, user: user }

      it 'should return right user'
    end

    context 'but authentication is not exist' do
      context 'and user have same email' do
        let(:auth_hash) { OmniAuth::AuthHash.new provider: provider, uid: uid, info: { email: email } }

        it 'should associate new authorization with user'
      end
    end
  end

  context 'when user is not exist' do
    context 'and authentication is not exist' do
      it 'should create user with authorization'
    end
  end
end
