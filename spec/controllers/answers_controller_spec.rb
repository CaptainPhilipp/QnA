require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:answer)   { create :answer, question: question }
  let(:with_question) { { question_id: question } }

  describe 'GET #index' do
    before { get :index, params: with_question }
    let(:answers) { create_list :answer, 2 + rand(5), question: question }

    it 'populates an array of answers' do
      expect(assigns :answers).to match_array(answers)
    end

    it 'renders view index' do
      should render_template :index
    end
  end

  describe 'GET #new' do
    before { get :new, params: with_question }
    let(:answer) { build :answer }

    it 'assigns a new Answer to @answer' do
      expect(assigns :answer).to be_a_new(Answer)
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
        should redirect_to answer_path(assigns :answer)
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
