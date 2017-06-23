require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:voices).dependent(:destroy) }

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
    it 'must return false if other user owns entity' do
      expect(user.owner? other_user_entity).to be false
    end

    it 'must return true if user owns entity' do
      expect(user.owner? users_entity).to be true
    end
  end

  describe '.find_for_oauth' do
    context 'when user exists' do
      let!(:authentication) { create :oauth_authorization, provider: provider, uid: uid, user: user }

      it 'should return right user' do
        expect(User.find_for_oauth auth_hash).to eq user
      end
    end

    context 'when user is not exists' do
      it 'should return nil' do
        expect(User.find_for_oauth auth_hash).to be nil
      end
    end
  end

  describe '.create_for_oauth' do
    before { User.create_for_oauth(auth_hash.info) }

    it 'should create user with right email' do
      expect(User.last.email).to eq email
    end
  end

  describe '.find_by_any' do
    before { user }

    it 'should find by any field' do
      # fields = { email: email }
      expect(User.find_by_any email: email).to eq user

      # fields.each do |field, value|
      #   expect(User.find_by_any field => value).to eq user
      # end
    end
  end
end
