require 'rails_helper'

RSpec.describe Api::V1::ProfilesController, type: :request do
  def self.request_list
    { get: ['profiles/me', 'profiles/'] }
  end

  it_behaves_like 'Api authenticateable'

  let(:path) { "/api/v1/profiles/#{action}" }

  context 'Authorized' do
    assign_user

    let(:access_token) { create(:access_token, resource_owner_id: user.id ).token }

    describe 'GET /me' do
      let(:action) { 'me' }

      before { get path, params: { access_token: access_token, format: :json } }

      it { expect(response).to be_success }

      %w(id email created_at updated_at).each do |field|
        it "contains #{field}" do
          expect(response.body).to be_json_eql(user.send(field).to_json).at_path(field)
        end
      end

      %w(password password_confirmation).each do |field|
        it "does not contains #{field}" do
          expect(response.body).to_not have_json_path(field)
        end
      end
    end

    describe 'GET /' do
      let(:action) { '' }
      let!(:other_users) { create_list :user, 3 }

      before { get path, params: { access_token: access_token, format: :json } }

      it { expect(response).to be_success }

      it 'contains users list with right length' do
        expect(response.body).to have_json_size(other_users.size)
      end

      it 'does not contains current resource owner' do
        expect(response.body).to_not include_json(user.to_json)
      end

      %w(id email created_at updated_at).each do |field|
        it "records contains #{field}" do
          expect(response.body).to have_json_path("0/#{field}")
        end
      end

      %w(password password_confirmation).each do |field|
        it "records does not contains #{field}" do
          other_users.size.times do |i|
            expect(response.body).to_not have_json_path("#{i}/#{field}")
          end
        end
      end
    end
  end
end
