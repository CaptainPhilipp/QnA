# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AnswersController, type: :request do
  def self.request_list
    { get: 'answers/1/', post: 'questions/1/answers/' }
  end

  it_behaves_like 'Api authenticateable'

  let!(:answer)   { create :answer, question: question }
  let!(:question) { create :question }
  let(:count)     { 3 }
  let(:params)    { attributes_for :answer, question_id: question.id }
  let(:path)      { "/api/v1/#{subpath}" }

  context 'Authorized' do
    assign_user
    let(:access_token) { create(:access_token, resource_owner_id: user.id).token }

    describe 'GET /show' do
      let!(:comments)    { create_list :comment, count, commentable: answer }
      let!(:attachments) { create_list :attachment, count, attachable: answer }
      let!(:answer)      { create :answer }

      let(:subpath) { "answers/#{answer.id}" }

      before do
        get path, params: { access_token: access_token, format: :json }
      end

      it_behaves_like('Contains fields', :answer, %w[id body created_at updated_at])
      it_behaves_like('Contains associations', %w[comments attachments])
      it_behaves_like('Associations contains field', comments: :body, attachments: :file)
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
