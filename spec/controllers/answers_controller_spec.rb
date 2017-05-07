require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user)     { create :user }
  let(:question) { create :question, user: create(:user) }
  let(:answer)   { create :answer, question: question, user: user }

  describe 'POST #create' do
    let(:send_request) { post :create, params: { question_id: question.id, answer: attributes } }
    let(:attributes) { attributes_for(:answer) }

    context 'when signed in' do
      before { login_user(user) }

      context 'builded answer' do
        before { send_request }

        it 'have right owner' do
          expect(assigns(:answer).user_id).to eq user.id
        end

        it 'have right question' do
          expect(assigns(:answer).question_id).to eq question.id
        end
      end

      context 'when user is owner' do
        context 'with valid attrs' do
          it 'saves new answer' do
            expect { send_request }.to change(question.answers, :count).by 1
          end

          it 'redirects to new answer' do
            send_request
            should redirect_to question_url(question)
          end
        end

        context 'with invalid attrs' do
          let(:attributes) { attributes_for(:invalid_answer) }

          it 'does not save the answer' do
            expect { send_request }.to_not change(Answer, :count)
          end

          it 're-renders new view' do
            send_request
            should render_template 'questions/show', id: question
          end
        end
      end
    end

    context 'when user is not signed in' do
      it 'should redirect to sign in' do
        send_request
        should redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:answer_params) { { id: answer.id } }
    let(:send_request) { delete :destroy, params: answer_params }

    context 'when owner' do
      before { login_user(user) }

      it 'deletes his answer' do
        answer
        expect { send_request }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        send_request
        should redirect_to question_url(answer.question)
      end
    end

    context 'when not owner' do
      before { login_user(create :user) }

      it 'deletes his question' do
        answer
        expect { send_request }.to_not change(question.answers, :count)
      end
    end
  end
end
