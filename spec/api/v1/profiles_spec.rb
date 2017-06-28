require 'rails_helper'

RSpec.describe Api::V1::ProfilesController, type: :controller do
  describe 'Profile API' do
    context 'When unauthorized' do
      let(:controller) { 'api/v1/profiles' }

      %i(me users).each do |action|
        describe "GET /#{action}" do
          it 'returns 401 if have no access_token' do
            get action, format: :json
            expect(response.status).to eq 401
          end

          it 'returns 401 if access_token is invalid' do
            get action, params: { access_token: '12342' }, format: :json
            expect(response.status).to eq 401
          end
        end
      end
    end

    describe 'GET /me' do
      let(:controller) { 'api/v1/profiles' }

      context 'unauthorized' do
      end
    end
  end
end
