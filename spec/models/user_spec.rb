require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:voices).dependent(:destroy) }

  assign_users
  let(:users_entity)      { create :question, user: user }
  let(:other_user_entity) { create :question, user: other_user }
  let(:auth_hash) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }

  describe '#owner?' do
    it 'must return false if other user owns entity' do
      expect(user.owner? other_user_entity).to be false
    end

    it 'must return true if user owns entity' do
      expect(user.owner? users_entity).to be true
    end
  end

  describe '.find_for_oauth'
  describe '.create_for_oauth'
  describe '.find_by_any'
end
