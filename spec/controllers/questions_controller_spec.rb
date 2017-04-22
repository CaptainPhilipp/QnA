require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    before { get :index }

    it 'populates an array of questions' do
      questions = FactoryGirl.create_list :question, 2 + rand(5)
      expect(assigns :questions).to match_array(questions)
    end

    it 'renders view index' do
      expect(response).to render_template(:index)
    end
  end
end
