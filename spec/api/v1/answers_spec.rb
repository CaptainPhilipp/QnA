require 'rails_helper'

RSpec.describe Api::V1::AnswersController, type: :request do
  def self.request_list
    { get: 'answers/1/', post: 'questions/1/answers/' }
  end

  it_behaves_like 'Api authenticateable'

  let!(:answer)   { create :answer, id: 1, question: question }
  let!(:question) { create :question, id: 1 }
  let(:params)    { attributes_for :answer, question_id: question.id }
  let(:path)      { "/api/v1/#{subpath}" }

  context 'Authorized' do
    assign_user
    let(:access_token) { create(:access_token, resource_owner_id: user.id).token }

    describe 'GET /show' do
      let!(:comments)    { create_list :comment, 3, commentable: answer }
      let!(:attachments) { create_list :attachment, 3, attachable: answer }
      let!(:answer)      { create :answer }

      let(:subpath) { "answers/#{answer.id}" }

      before do
        get path, params: { access_token: access_token, format: :json }
      end

      %w[id body created_at updated_at].each do |field|
        it "answer contains #{field}" do
          expect(response.body).to be_json_eql(answer.send(field).to_json).at_path(field)
        end
      end

      %w[comments attachments].each do |association|
        it "answer contains #{association} association" do
          expect(response.body).to have_json_size(3).at_path(association)
        end
      end

      it 'comments association contains body' do
        expect(response.body).to be_json_eql(comments.last.body.to_json)
          .at_path('comments/0/body')
      end
    end

    describe 'POST /create' do
      let(:params)  { attributes_for :answer, question_id: question.id, access_token: access_token, format: :json }
      let(:subpath) { "questions/#{question.id}/answers" }

      before { post path, params: params }

      it 'creates an answer with right body' do
        expect(response.body).to be_json_eql(params[:body].to_json).at_path('body')
      end
    end
  end
end
