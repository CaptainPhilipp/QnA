require 'rails_helper'

shared_examples 'Rated concern' do
  assign_user :other_user
  login_user
  let(:rateable) { create controller.controller_name.singularize, user: other_user }
  let(:send_request) { post :vote, params: { id: rateable, value: sending_value }, format: :json }

  context 'when rateable already rated' do
    before { rateable.rate_up_by user }
    context 'value = "cancel"' do
      let(:sending_value) { 'cancel' }

      it 'should cancel voice', js: true do
        expect(rateable.rated_by? user).to be true
        send_request
        expect(rateable.reload.rating).to eq 0
      end
    end

    context 'value = -1' do
      let(:sending_value) { '-1' }

      it 'should not change rating' do
        expect(rateable.rating).to eq 1
        send_request
        expect(rateable.reload.rating).to eq 1
      end

      it 'should respond with error' do
        send_request
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  context 'when value is 1' do
    let(:sending_value) { '1' }

    it 'should rate up rateable entity' do
      expect(rateable.rating).to eq 0
      send_request
      expect(rateable.reload.rating).to eq 1
    end
  end

  context 'when value is -1' do
    let(:sending_value) { '-1' }

    it 'should rate down rateable entity' do
      expect(rateable.rating).to eq 0
      send_request
      expect(rateable.reload.rating).to eq(-1)
    end
  end

  context 'when user is owner' do
    login_user :other_user
    let(:sending_value) { '-1' }

    it 'should not change rating' do
      expect(rateable.rating).to eq 0
      send_request
      expect(rateable.reload.rating).to eq 0
    end
  end
end
