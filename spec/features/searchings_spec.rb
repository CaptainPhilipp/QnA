require_relative 'acceptance_helper'

RSpec.feature "Searching", type: :feature do
  let(:query) { 'Searcheable' }
  let(:body) { "Body #{query}" }
  let(:question_with_title) { create :question, title: "Title #{query}" }
  let(:question_with_body)  { create :question, body: body }
  let(:answer_with_body)    { create :answer,   body: body }
  let(:comment_with_body)   { create :comment,  body: body }

  fcontext 'with all types of content' do
    before { visit root_path }

    it_behaves_like 'sends search request', entity: :question_with_title
    it_behaves_like 'sends search request', entity: :question_with_body
    it_behaves_like 'sends search request', entity: :answer_with_body
    it_behaves_like 'sends search request', entity: :comment_with_body
  end
end
