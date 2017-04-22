require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    before { get :index }
    let(:questions) { create_list :question, 2 + rand(5) }

    it 'populates an array of questions' do
      expect(assigns :questions).to match_array(questions)
    end

    it 'renders view index' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }
    let(:question) { create :question }

    it 'assigns requested question to @question' do
      expect(assigns :question).to eq(question)
    end

    it { should render_template(:show) }
  end

  describe 'GET #new' do
    before { get :new }
    let(:question) { build :question }

    it 'assigns a new Question to @question' do
      expect(assigns :question).to be_a_new(Question)
    end

    it { should render_template(:new) }
  end

end
