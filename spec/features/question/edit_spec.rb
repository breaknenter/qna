require 'rails_helper'

feature 'User can edit his question' do
  given!(:user)     { create(:user) }
  given!(:question) { create(:question, author: user) }

  given!(:user2)     { create(:user) }
  given!(:question2) { create(:question, author: user2) }

  describe 'Authenticated user', js: true do
    before { sign_in(user) }

    scenario 'edit his question' do
      visit question_path(question)
      click_link 'edit'
      fill_in 'Text', with: 'Edited question'
      click_button 'save'

      expect(page).to_not have_content  question.text
      expect(page).to     have_content  'Edited question'
      expect(page).to_not have_selector 'textarea'
    end

    scenario 'edit his question with errors' do
      visit question_path(question)

      click_link 'edit'
      fill_in 'Text', with: ''
      click_button 'save'

      expect(page).to have_content  "Text can't be blank"
    end

    scenario 'try to edit other user question' do
      visit question_path(question2)

      expect(page).to_not have_link 'edit'
    end
  end

  scenario 'Unauthenticated user can not edit question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'edit'
  end
end
