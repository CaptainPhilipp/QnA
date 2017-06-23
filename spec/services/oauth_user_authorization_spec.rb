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
    before { user }

    context 'and authentication exist' do
      let!(:authentication) { create :oauth_authorization, provider: provider, uid: uid, user: user }

      it 'should return right user' do
        expect(OauthUserAuthorization.new(auth_hash).call).to eq user
      end
    end

    context 'but authentication is not exist' do
      context 'and user have same email' do
        let(:auth_hash) { OmniAuth::AuthHash.new provider: provider, uid: uid, info: { email: email } }

        it 'should associate new authorization with user' do
          expect(user.oauth_authorizations).to be_empty
          OauthUserAuthorization.new(auth_hash).call
          expect(user.oauth_authorizations.count).to eq 1
          expect(user.oauth_authorizations.first.uid).to eq uid
        end
      end
    end
  end

  context 'when user is not exist' do
    context 'and authentication is not exist' do
      it 'should create user' do
        expect { OauthUserAuthorization.new(auth_hash).call }.to change(User, :count).by(1)
        expect(User.last.oauth_authorizations.last).to eq OauthAuthorization.last
      end

      it 'should create association' do
        expect { OauthUserAuthorization.new(auth_hash).call }.to change(OauthAuthorization, :count).by(1)
        expect(OauthAuthorization.last.user).to eq User.last
      end
    end
  end
end
