require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :request do
  let(:count) { 3 }
  let(:questions) { create_list :question, count }
  let(:question)  { questions.first }

  let(:params) { attributes_for :question }

  let(:path) { "/api/v1/questions/#{subpath}" }

  describe 'Questions API' do
    context 'Unauthorized' do
      { get: ['', '1'], post: [''] }.each do |http_method, subpaths|
        subpaths.each do |subpath|
          let(:subpath) { subpath }

          describe "#{http_method.upcase} /#{subpath}" do
            let!(:question) { create :question }

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
    end

    context 'Authorized' do
      assign_user
      let(:access_token) { create(:access_token, resource_owner_id: user.id).token }

      let!(:answers)      { create_list :answer, count, question: question }
      let!(:comments)     { create_list :comment, count, commentable: question }
      let!(:attachments)  { create_list :attachment, count, attachable: question }

      let(:params) { { access_token: access_token, format: :json } }

      describe 'GET /index' do
        let(:subpath) { '' }
        before { get path, params: params }

        it 'contains questions' do
          expect(response.body).to have_json_size(count)
        end

        %w[id title body created_at updated_at].each do |field|
          it "questions contains #{field}" do
            expect(response.body).to be_json_eql(question.send(field).to_json).at_path("0/#{field}")
          end
        end

        %w[answers comments attachments].each do |association|
          it "does not contains #{association}" do
            expect(response.body).to_not have_json_path("0/#{association}")
          end
        end
      end

      describe 'GET /show' do
        let(:subpath) { question.id }
        before { get path, params: params }

        %w[id title body created_at updated_at].each do |field|
          it "question contains #{field} field" do
            expect(response.body).to be_json_eql(question.send(field).to_json).at_path(field)
          end
        end

        %w[answers comments attachments].each do |association|
          it "question contains #{association}" do
            expect(response.body).to have_json_size(count).at_path(association)
          end
        end

        %w[answers comments].each do |association|
          it "#{association} association contains body" do
            expect(response.body).to be_json_eql(send(association).last.body.to_json)
              .at_path("#{association}/0/body")
          end
        end
      end

      describe 'POST /create' do
        let(:extended_params) { params.merge attributes_for(:question) }
        let(:subpath) { '' }

        before { post path, params: extended_params }

        %w[body title].each do |field|
          it "creates an answer with right #{field}" do
            expect(response.body).to be_json_eql(extended_params[field.to_sym].to_json).at_path(field)
          end
        end
      end
    end
  end
end
