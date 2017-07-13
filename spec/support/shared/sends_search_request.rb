require 'rails_helper'

RSpec.shared_examples_for 'sends search request' do |entity:|
  scenario "tryes to find #{entity}", sphinx: true do
    send(entity)
    index

    within '#search_form' do
      fill_in 'query', with: query
      click_on 'Search!'
    end

    expect(page).to have_content query
  end
end
