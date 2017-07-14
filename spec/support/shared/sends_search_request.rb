require 'rails_helper'

RSpec.shared_examples_for 'sends search request' do |try_to_find:|
  scenario "tryes to find #{try_to_find}", sphinx: true do
    send(try_to_find)

    within '#search_form' do
      fill_in 'query', with: query
      click_on 'Search!'
    end

    expect(page).to have_content query
  end
end
