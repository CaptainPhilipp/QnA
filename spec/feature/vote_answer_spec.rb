require_relative 'acceptance_helper'

shared_examples :sholdnt_have_voting_link do
  scenario "shoultn't see voting link" do
    visit question_path(question)
    expect(page).to_not have_selector '.rate_up_link'
    expect(page).to_not have_selector '.rate_down_link'
  end
end

feature 'User can change rating of answes', '
    In order to rate an answer,
    User can vote for answer of other oser
  ' do

  assign_users :user, :other_user

  let(:question) { create :question, user: user }
  let!(:answer)  { create :answer, question: question }

  let(:answer_selector) { "#answer_#{answer.id}" }
  let(:best_answer_link) { Answer.human_attribute_name(:best) }

  context 'When authenticated as not owner,' do
    login_user :other_user
    before { visit question_path(question) }

    context 'and when answer is not rated by user' do
      scenario 'User can rate up the answer'
      scenario 'User can rate down the answer'
      scenario "User don't see button for cancel voice"
    end

    context 'and when already rated for answer' do
      scenario "User can't change rating of answer"
      scenario "User can cancel his voice"
    end
  end

  context 'When authenticated as owner,' do
    login_user
    include_examples :sholdnt_have_voting_link
  end

  context 'When not authenticated,' do
    include_examples :sholdnt_have_voting_link
  end
end
