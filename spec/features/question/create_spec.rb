require 'rails_helper'

feature 'User can create question', %(
  To get a response from the community,
  I, as an authenticated user,
  would like to create a question
) do
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    scenario 'creates a question' do
      visit questions_path
      click_link 'Ask question'

      fill_in 'Title', with: 'Test title'
      fill_in 'Text',  with: 'Test text'
      click_button 'Ask'

      expect(page).to have_content 'Your question created.'
      expect(page).to have_content 'Test title'
      expect(page).to have_content 'Test text'
    end

    scenario 'creates a question with errors' do
      visit new_question_path
      click_button 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'An unauthenticated user is trying to post a question' do
    visit questions_path
    click_link 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end