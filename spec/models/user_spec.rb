require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:voices).dependent(:destroy) }
  it { should have_many(:oauth_authorizations).dependent(:destroy) }

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

  describe '.send_daily_digest' do
    let!(:users)     { create_list :user, 3 }
    let!(:questions) { create_list :question, 3 }

    it 'sends mail with digest to each user' do
      User.find_each do |user|
        expect(DailyMailer).to receive(:digest).with(user).and_call_original
      end

      User.send_daily_digest
    end
  end
end
