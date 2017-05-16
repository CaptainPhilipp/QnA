require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  assign_users :user, :other_user
  let(:question) { create :question, user: user }
  let(:answer)   { create :answer, question: question, user: user }

  describe 'POST #create' do
    let(:attributes) { attributes_for(:answer) }
    let(:send_request)      { post :create, params: { question_id: question.id, answer: attributes } }
    let(:send_ajax_request) { post :create, params: { question_id: question.id, answer: attributes, format: :js } }

    context 'when signed in' do
      login_user

      context 'builded answer' do
        before { send_ajax_request }

        it 'have right owner' do
          expect(assigns(:answer).user_id).to eq user.id
        end

        it 'have right question' do
          expect(assigns(:answer).question_id).to eq question.id
        end
      end

      context 'creating answer' do
        context 'with valid attrs' do
          it 'saves new answer' do
            expect { send_ajax_request }.to change(question.answers, :count).by 1
          end
        end

        context 'with invalid attrs' do
          let(:attributes) { attributes_for(:invalid_answer) }

          it 'does not save the answer' do
            expect { send_ajax_request }.to_not change(Answer, :count)
          end
        end
      end
    end

    context "when user isn't signed in" do
      context 'with ajax request' do
        it 'should respond_with 401' do
          send_ajax_request
          should respond_with 401
        end
      end

      context 'with normal request' do
        it 'should redirect to sign in' do
          send_request
          should redirect_to new_user_session_url
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:attributes) { attributes_for :answer }
    let(:new_attributes) { attributes_for :new_answer }
    let(:send_request) { patch :update, params: {
      id: answer, format: :js, answer: { body: new_attributes[:body] }
    } }

    context 'when user is owner' do
      login_user

      it "can update his answer" do
        send_request
        expect(answer.reload.body).to eq new_attributes[:body]
      end
    end

    context 'when not owner' do
      login_user :other_user

      it "can't update answer" do
        expect { send_request }.to_not change(answer.reload, :body)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:answer_params) { { id: answer } }
    let(:send_ajax_request) { delete :destroy, params: answer_params, format: :js }

    context 'when owner' do
      login_user

      it 'deletes his answer' do
        answer
        expect { send_ajax_request }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        send_ajax_request
        should_not redirect_to question_url(answer.question)
      end
    end

    context 'when not owner' do
      login_user :other_user

      it "can't delete question" do
        answer
        expect { send_ajax_request }.to_not change(question.answers, :count)
      end
    end
  end

  describe 'PATCH #best' do
    let(:send_ajax_request) { patch :best, params: { id: answer }, format: :js }

    context 'when owner' do
      login_user

      it 'must set new best' do
        send_ajax_request
        expect(answer.reload).to be_best
      end
    end

    context 'when not owner' do
      login_user :other_user

      it 'must not set best' do
        send_ajax_request
        expect(answer.reload).to_not be_best
      end
    end
  end
end
