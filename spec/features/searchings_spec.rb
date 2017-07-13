require_relative 'acceptance_helper'

RSpec.feature "Searching", type: :feature, sphinx: true do
  let(:query) { 'Searcheable' }

  before { visit root_path }

  context 'with all types of content' do
    let(:body) { "Body #{query}" }
    let(:question_with_title) { create :question, title: "Title #{query}" }
    let(:question_with_body)  { create :question, body: body }
    let(:answer_with_body)    { create :answer,   body: body }
    let(:comment_with_body)   { create :comment,  body: body }

    it_behaves_like 'sends search request', entity: :question_with_title
    it_behaves_like 'sends search request', entity: :question_with_body
    it_behaves_like 'sends search request', entity: :answer_with_body
    it_behaves_like 'sends search request', entity: :comment_with_body
  end

  context 'with a few types of content' do
    let!(:question) { create :question, body: "#{query} KeywordQuestion" }
    let!(:answer)   { create :answer,   body: "#{query} KeywordAnswer" }
    let!(:comment)  { create :comment,  body: "#{query} KeywordComment" }

    before { index }

    scenario 'tryes to find Answer within Question type' do
      within '#search_form' do
        fill_in 'query', with: query

        within('#select_type') do
          check 'Question'
          check 'Comment'
        end

        click_on 'Search!'
      end

      expect(page).to have_content 'KeywordQuestion'
      expect(page).to have_content 'KeywordComment'
      expect(page).to_not have_content 'KeywordAnswer'
    end
  end
end
