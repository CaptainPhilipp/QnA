require 'rails_helper'

feature 'create question', %q(
    In order to get answer from community,
    User can ask the question
  ) do

  let(:question) { { title: 'Question title', body: 'Question body' } }

  scenario 'create Link must exist' do
    new_question_from_index
    expect(current_path).to eq new_question_path
  end

  scenario 'after create, user can see his question' do
    new_question_from_index
    create_question_with_form
    expect(page).to have_content question[:title]
    expect(page).to have_content question[:body]
  end
end
