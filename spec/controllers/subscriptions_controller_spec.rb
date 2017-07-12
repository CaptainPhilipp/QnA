# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  login_user
  let!(:question) { create :question }

  describe 'POST #create' do
    let(:send_request) { post :create, params: { question_id: question.id } }

    it 'creates subscription' do
      expect { send_request }.to change(Subscription, :count).by(1)
    end

    it 'created subscription have right user and question' do
      send_request
      subscription = Subscription.last
      expect(subscription.user).to eq user
      expect(subscription.question).to eq question
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create :subscription, user: user, question: question }
    let(:send_request) { delete :destroy, params: { question_id: question.id } }

    it 'deletes subscription' do
      expect { send_request }.to change(Subscription, :count).by(-1)
    end
  end
end
