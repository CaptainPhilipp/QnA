require 'rails_helper'

RSpec.describe OauthAuthorization, type: :model do
  it { should belong_to :user }
  it { should have_db_column :provider }
  it { should have_db_column :uid }

  let(:auth_hash) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }

  describe '.find_or_create' do
    it 'should return OauthAuthorization' do
      authorization = OauthAuthorization.find_or_create_by_auth_hash(auth_hash)
      expect(authorization.class).to be OauthAuthorization
      expect(authorization).to be_persisted
    end
  end

  describe '.find_or_create'
  describe '.select_fields_from'
end
