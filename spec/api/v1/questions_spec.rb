require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :request do
  def self.request_list
    { get: ['questions/', 'questions/1'], post: 'questions/' }
  end

  it_behaves_like 'Api authenticateable'

  let(:path) { "/api/v1/questions/#{subpath}" }
  let(:count) { 3 }
  let(:questions) { create_list :question, count }
  let(:question)  { questions.first }
  let(:params) { attributes_for :question }

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

      it_behaves_like('Contains fields', :question, %w[id title body created_at updated_at], '0/')

      %w[answers comments attachments].each do |association|
        it "does not contains #{association}" do
          expect(response.body).to_not have_json_path("0/#{association}")
        end
      end
    end

    describe 'GET /show' do
      let(:subpath) { question.id }
      before { get path, params: params }

      it_behaves_like('Contains fields', :question, %w[id title body created_at updated_at])
      it_behaves_like('Contains associations', %w[answers comments attachments])
      it_behaves_like('Associations contains field', comments: :body, answers: :body)
    end

    describe 'POST /create' do
      let(:extended_params) { params.merge attributes_for(:question) }
      let(:subpath) { '' }

      before { post path, params: extended_params }

      %w[body title].each do |field|
        it "creates a question with right #{field}" do
          expect(response.body).to be_json_eql(extended_params[field.to_sym].to_json)
            .at_path(field)
        end
      end
    end
  end
end
