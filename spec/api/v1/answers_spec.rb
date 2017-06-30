require 'rails_helper'

RSpec.describe Api::V1::AnswersController, type: :controller do
  assign_user
  let!(:question) { create :question }
  let!(:answer)   { create :answer, question: question }
  let(:params)    { attributes_for :answer, question_id: question.id }

  describe 'Questions API' do
    context 'Unauthorized' do
      describe "GET /show" do
        it 'returns 401 if have no access_token' do
          get :show, params: { id: answer.id }, format: :json

          expect(response.status).to eq 401
        end

        it 'returns 401 if access_token is invalid' do
          get :show, params: { id: answer.id, access_token: '12342' }, format: :json

          expect(response.status).to eq 401
        end
      end

      describe "POST /create" do
        it 'returns 401 if have no access_token' do
          post :create, params: { id: answer.id, question_id: question.id }, format: :json

          expect(response.status).to eq 401
        end

        it 'returns 401 if access_token is invalid' do
          get :create, params: { question_id: question.id, access_token: '12342' }, format: :json

          expect(response.status).to eq 401
        end
      end
    end

    context 'Authorized' do
      assign_user
      let(:access_token) { create(:access_token, resource_owner_id: user.id ).token }

      describe 'GET /show' do
        let!(:comments)  { create_list :comment, 3, commentable: answer }
        # let!(:attachments)  { create_list :attachment, 3, attacheble: answer }

        before { get :show, params: { id: answer.id, access_token: access_token }, format: :json }

        %w(id body created_at updated_at).each do |field|
          it "answer should contain #{field}" do
            expect(response.body).to be_json_eql(answer.send(field).to_json).at_path(field)
          end
        end

        %w(comments attachments).each do |association|
          it "should contains #{association}" do
            expect(response.body).to have_json_size(3).at_path(association)
          end
        end

        it 'should have data in associated collections'
      end

      describe 'POST /create' do
        before { post :create, params: params.merge(access_token: access_token) , format: :json }

        it 'should create an answer with right body' do
          expect(response.body).to be_json_eql(params[:body].to_json).at_path('body/')
        end
      end
    end
  end
end
