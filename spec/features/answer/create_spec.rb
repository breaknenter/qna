require 'rails_helper'

feature 'The user, being on the question page, can write an answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'authenticated user creates a answer' do
    background { sign_in(user) }
    background { visit question_path question }

    scenario 'create valid answer' do
      fill_in 'Text', with: 'Answer text'
      click_button 'Answer'

      expect(page).to have_content 'Answer created'
      expect(page).to have_content 'Answer text'
    end

    scenario 'create invalid answer' do
      click_button 'Answer'

      expect(page).to have_content "Text can't be blank"
    end
  end

  describe 'unauthenticated user creates a answer' do
    scenario 'tries to answer a question' do
      visit question_path question

      expect(page).not_to have_button 'Answer'
    end
  end
end
