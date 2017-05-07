require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  let(:user)              { create :user }
  let(:users_entity)      { create :question, user: user }
  let(:other_user_entity) { create :question, user: create(:user) }

  describe '#owner?' do
    it 'must return false if other user owns entity' do
      user.owner? other_user_entity
    end

    it 'must return true if user owns entity' do
      user.owner? users_entity
    end
  end
end
