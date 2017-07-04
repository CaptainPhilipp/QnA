require 'rails_helper'

RSpec.describe Api::V1::AnswersController, type: :request do
  assign_user
  let!(:question) { create :question, id: 1 }
  let!(:answer)   { create :answer, id: 1, question: question }
  let(:params)    { attributes_for :answer, question_id: question.id }
  let(:path)      { "/api/v1/#{subpath}" }

  describe 'Questions API' do
    context 'Unauthorized' do
      { get: 'answers/1', post: 'questions/1/answers' }.each do |http_method, subpath|
          describe "#{http_method.upcase} /#{subpath}" do
            let(:subpath) { subpath }

            it 'returns 401 if have no access_token' do
              send http_method, path, params: { format: :json }

              expect(response.status).to eq 401
            end

            it 'returns 401 if access_token is invalid' do
              send http_method, path, params: { access_token: '12342', format: :json }

              expect(response.status).to eq 401
            end
          end
      end
    end

    context 'Authorized' do
      assign_user
      let(:access_token) { create(:access_token, resource_owner_id: user.id ).token }

      describe 'GET /show' do
        let!(:comments)    { create_list :comment, 3, commentable: answer }
        let!(:attachments) { create_list :attachment, 3, attachable: answer }
        let!(:answer)      { create :answer }

        let(:subpath) { 'answers/1' }

        before { get path,
                  { access_token: access_token, format: :json },
                  { "ACCEPT" => "application/json", format: :json, "HTTP_ACCEPT" => "application/json" } }

        %w(id body created_at updated_at).each do |field|
          it "answer contains #{field}" do
            expect(response.body).to be_json_eql(answer.send(field).to_json).at_path(field)
          end
        end

        %w(comments attachments).each do |association|
          it "answer contains #{association} association" do
            expect(response.body).to have_json_size(3).at_path(association)
          end
        end

        it "comments association contains body" do
          expect(response.body).to be_json_eql(comments.last.body.to_json).at_path("comments/0/body")
        end
      end

      describe 'POST /create' do
        before { post :create, params: params.merge(access_token: access_token) , format: :json }

        it 'creates an answer with right body' do
          expect(response.body).to be_json_eql(params[:body].to_json).at_path('body')
        end
      end
    end
  end
end
