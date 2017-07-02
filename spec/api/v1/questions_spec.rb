require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :controller do
  let(:count) { 3 }
  let(:questions) { create_list :question, count }
  let(:question)  { questions.first }

  let(:params) { attributes_for :question }

  describe 'Questions API' do
    context 'Unauthorized' do
      { get: %i(index show), post: %i(create) }.each do |http_method, actions|
        actions.each do |action|

          describe "#{http_method.upcase} /#{action}" do
            let!(:question) { create :question }

            it 'returns 401 if have no access_token' do
              send http_method, action, params: { id: question.id }, format: :json

              expect(response.status).to eq 401
            end

            it 'returns 401 if access_token is invalid' do
              send http_method, action, params: { id: question.id, access_token: '12342' }, format: :json

              expect(response.status).to eq 401
            end
          end

        end
      end
    end

    context 'Authorized' do
      assign_user
      let(:access_token) { create(:access_token, resource_owner_id: user.id ).token }

      let!(:answers)      { create_list :answer, count, question: question }
      let!(:comments)     { create_list :comment, count, commentable: question }
      let!(:attachments)  { create_list :attachment, count, attachable: question }

      describe 'GET /index' do
        before { get :index, params: { access_token: access_token }, format: :json }

        it 'contains questions' do
          expect(response.body).to have_json_size(count)
        end

        %w(id title body created_at updated_at).each do |field|
          it "questions contains #{field}" do
            expect(response.body).to be_json_eql(question.send(field).to_json).at_path("0/#{field}")
          end
        end

        %w(answers comments attachments).each do |association|
          it "does not contains #{association}" do
            expect(response.body).to_not have_json_path("0/association")
          end
        end
      end

      describe 'GET /show' do
        before { get :show, params: { id: question.id, access_token: access_token }, format: :json }

        %w(id title body created_at updated_at).each do |field|
          it "question contains #{field} field" do
            expect(response.body).to be_json_eql(question.send(field).to_json).at_path(field)
          end
        end

        %w(answers comments attachments).each do |association|
          it "question contains #{association}" do
            expect(response.body).to have_json_size(count).at_path(association)
          end
        end

        %w(answers comments).each do |association|
          it "#{association} association contains body" do
            expect(response.body).to be_json_eql(send(association).last.body.to_json)
              .at_path("#{association}/0/body")
          end
        end
      end

      describe 'POST /create' do
        let(:params) { attributes_for :question }
        before { post :create, params: params.merge(access_token: access_token) , format: :json }

        %w(body title).each do |field|
          it "creates an answer with right #{field}" do
            expect(response.body).to be_json_eql(params[field.to_sym].to_json).at_path(field)
          end
        end
      end
    end
  end
end
