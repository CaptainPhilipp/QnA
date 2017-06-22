require 'rails_helper'

RSpec.describe OauthUserAuthorization do
  let(:auth_hash) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }

  it 'should return User object' do
    expect(OauthUserAuthorization.new(auth_hash).call).to be_a User
  end

  context 'when user exists' do
    it 'should return right user'
  end

  context "when user isn't exists" do
    it 'should return created user'
  end
end
