require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  assign_users
  let(:question) { create :question, user: user }

  describe 'GET #index' do
    before { get :index }
    let(:questions) { create_list :question, 3, user: user }

    it 'populates an array of questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders view index' do
      should render_template :index
    end
  end

  describe 'GET #show' do
    let(:answers) { create_list :answer, 3, question: question, user: user }

    before do
      answers
      get :show, params: { id: question }
    end

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'prepares new @answer' do
      expect(assigns(:answer)).to be_a_new Answer
    end

    it { should render_template :show }
  end

  describe 'GET #new' do
    login_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it { should render_template :new }
  end

  describe 'GET #edit' do
    let(:send_request) { get :edit, params: { id: question } }

    context 'Owner' do
      login_user
      before { send_request }

      it 'assigns requested question to @question' do
        expect(assigns(:question)).to eq(question)
      end

      it { should render_template :edit }
    end

    context 'Not owner' do
      login_user :other_user
      before { send_request }

      it { should redirect_to question_path(question) }
    end
  end

  describe 'POST #create' do
    login_user
    let(:attributes) { attributes_for(:question) }
    let(:send_request) { post :create, params: { question: attributes } }

    it '@question must have right owner' do
      send_request
      expect(assigns(:question).user_id).to eq user.id
    end

    context 'with valid attrs' do
      it 'saves new question' do
        expect { send_request }.to change(Question, :count)
      end

      it 'redirects to new question' do
        send_request
        should redirect_to question_path(assigns(:question))
      end

      fit 'creates subscription for author' do
        send_request
        expect(Question.last.subscriptions.first.user_id).to eq user.id
      end
    end

    context 'with invalid attrs' do
      let(:attributes) { attributes_for(:invalid_question) }

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
    let(:attributes)     { attributes_for(:question) }
    let(:new_attributes) { attributes_for(:new_question) }
    let(:send_request)   { patch :update, params: { id: question, question: new_attributes } }

    context 'when right owner' do
      login_user

      it 'assings the requested question to @question' do
        send_request
        expect(assigns(:question).id).to eq question.id
      end

      context 'valid attributes' do
        before { send_request }

        it 'changes question attributes' do
          expect(assigns(:question).title).to eq new_attributes[:title]
          expect(assigns(:question).body).to  eq new_attributes[:body]
        end

        it 'redirects to the updated question' do
          should redirect_to question
        end
      end

      context 'invalid attributes' do
        let(:new_attributes) { attributes_for(:invalid_question) }

        it 'not changes question attributes' do
          expect { send_request }.to_not change_results(question, any: [:title, :body])
        end

        it 'redirects to the updated question' do
          send_request
          should render_template :edit
        end
      end
    end

    context 'when not owner' do
      login_user :other_user
      before { send_request }

      it 'not changes question attributes' do
        expect(assigns(:question)).to eq question
      end

      it { should redirect_to question_url(question) }
    end
  end

  describe 'DELETE #destroy' do
    let(:question_params) { { id: question } }
    let(:send_request) { delete :destroy, params: question_params }

    context 'when owner' do
      login_user

      it 'deletes his question' do
        question
        expect { send_request }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        send_request
        should redirect_to :questions
      end
    end

    context 'when not owner' do
      login_user :other_user

      it 'deletes his question' do
        question
        expect { send_request }.to_not change(Question, :count)
      end
    end
  end

  it_behaves_like 'Rated concern'
end
