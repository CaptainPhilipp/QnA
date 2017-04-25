require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create :question }

  describe 'GET #index' do
    before { get :index }
    let(:questions) { create_list :question, 2 + rand(5) }

    it 'populates an array of questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders view index' do
      should render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }
    let(:question) { create :question }
    let(:answers) { create_list :answer, 2 + rand(5), question: question }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'populates an array of answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it { should render_template :show }
  end

  describe 'GET #new' do
    before { get :new }
    let(:question) { build :question }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it { should render_template :new }
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: question } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it { should render_template :edit }
  end

  describe 'POST #create' do
    let(:send_request) { post :create, params: question_params }

    context 'with valid attrs' do
      let(:question_params) { { question: attributes_for(:question) } }

      it 'saves new question' do
        expect { send_request }.to change(Question, :count)
      end

      it 'redirects to new question' do
        send_request
        should redirect_to question_path(assigns :question)
      end
    end

    context 'with invalid attrs' do
      let(:question_params) { { question: attributes_for(:invalid_question) } }

      it 'does not save the question' do
        expect { send_request }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        send_request
        should render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:question_params) { { question: attributes }.merge(id: question) }

    it 'assings the requested question to @question' do
      patch :update, params: { id: question, question: attributes_for(:question) }
      expect(assigns(:question)).to eq question
    end

    context 'valid attributes' do
      let(:attributes) { { title: 'new title', body: 'new body' } }

      it 'changes question attributes' do
        patch :update, params: question_params
        question.reload
        expect(question.title).to eq attributes[:title]
        expect(question.body).to eq attributes[:body]
      end

      it 'redirects to the updated question' do
        patch :update, params: question_params
        should redirect_to question
      end
    end

    context 'invalid attributes' do
      let(:attributes) { { title: '', body: '' } }

      it 'changes question attributes' do
        patch :update, params: { question: attributes, id: question }
        old_title, old_body = question.title, question.body
        question.reload
        expect(question.title).to eq old_title
        expect(question.body).to eq old_body
      end

      it 'redirects to the updated question' do
        patch :update, params: question_params
        should render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question_params) { { id: question } }
    let(:send_request) { delete :destroy, params: question_params }

    it 'deletes question' do
      question
      expect { send_request }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      send_request
      should redirect_to questions_url
    end
  end
end
