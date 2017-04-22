require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:answer)   { create :answer, question: question }
  let(:with_question) { { question_id: question } }

  describe 'GET #new' do
    before { get :new, params: with_question }
    let(:answer) { build :answer }

    it 'assigns a new Answer to @answer' do
      expect(assigns :answer).to be_a_new(Answer)
      expect(assigns(:answer).question).to eq(question)
    end

    it { should render_template :new }
  end

  describe 'POST #create' do
    let(:send_request) { post :create, params: answer_params }

    context 'with valid attrs' do
      let(:answer_params) { { question_id: question.id }.merge answer: attributes_for(:answer) }

      it 'saves new answer' do
        expect { send_request }.to change(question.answers, :count).by 1
      end

      it 'redirects to new answer' do
        send_request
        should redirect_to question_url(question)
      end
    end

    context 'with invalid attrs' do
      let(:answer_params) { { question_id: question.id }.merge answer: attributes_for(:invalid_answer) }

      it 'does not save the answer' do
        expect { send_request }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        send_request
        should render_template :new
      end
    end
  end
end
