require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:voices).dependent(:destroy) }
  it { should have_many(:oauth_authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  assign_user :other_user
  let(:user) { create :user, email: email }

  let(:email)     { 'example@example.com' }
  let(:provider)  { 'facebook' }
  let(:uid)       { '12341234' }

  let(:users_entity)      { create :question, user: user }
  let(:other_user_entity) { create :question, user: other_user }
  let(:auth_hash)      { OmniAuth::AuthHash.new provider: provider, uid: uid, info: { email: email } }
  let(:authentication) { create :oauth_authorization, provider: provider, uid: uid, user: user }

  describe '#owner?' do
    it 'returns false if other user owns entity' do
      expect(user.owner? other_user_entity).to be false
    end

    it 'returns true if user owns entity' do
      expect(user.owner? users_entity).to be true
    end
  end

  describe '#subscribe_to(question)' do
    let!(:question) { create :question }

    it 'creates subscription' do
      expect { user.subscribe_to(question) }.to change(Subscription, :count).by(1)
    end

    it 'created subscription have right user and question' do
      user.subscribe_to(question)
      expect(Subscription.last.user).to eq user
      expect(Subscription.last.question).to eq question
    end
  end

  describe '.find_with_uid' do
    context 'when user exists' do
      let!(:authentication) { create :oauth_authorization, provider: provider, uid: uid, user: user }

      it 'returns right user' do
        expect(User.find_with_uid provider: auth_hash.provider, uid: auth_hash.uid).to eq user
      end
    end

    context 'when user is not exists' do
      it 'returns nil' do
        expect(User.find_with_uid provider: auth_hash.provider, uid: auth_hash.uid).to be nil
      end
    end
  end

  describe '.create_without_pass' do
    before { User.create_without_pass(auth_hash.info) }

    it 'creates user with right email' do
      expect(User.last.email).to eq email
    end
  end
end
