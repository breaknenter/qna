require 'rails_helper'

feature 'The user can add comment to the question' do
  given!(:author)   { create(:user) }
  given!(:user)     { create(:user) }
  given!(:question) { create(:question, author: author) }

  context 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add comment' do
      within('#question-comments') do
        fill_in 'Text', with: 'Comment text'
        click_button 'Comment'
      end

      expect(page).to have_content 'Comment text'
    end
  end
end
