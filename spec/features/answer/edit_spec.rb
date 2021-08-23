require 'rails_helper'

feature 'User can edit his answer' do
  given!(:user)     { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer)   { create(:answer, question: question, author: user) }

  given!(:user2)     { create(:user) }
  given!(:question2) { create(:question, author: user2) }
  given!(:answer2)   { create(:answer, question: question2, author: user2) }

  describe 'Authenticated user', js: true do
    before { sign_in(user) }

    scenario 'edit his answer' do
      visit question_path(question)

      within('.answers-list') do
        click_link 'edit'
        fill_in 'Text', with: 'Edited answer'
        click_button 'save'

        expect(page).to_not have_content  answer.text
        expect(page).to     have_content  'Edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors' do
      visit question_path(question)

      within('.answers-list') do
        click_link 'edit'
        fill_in 'Text', with: ''
        click_button 'save'
      end

      expect(page).to have_content  "Text can't be blank"
    end

    scenario 'try to edit other user answer' do
      visit question_path(question2)

      expect(page).to_not have_link 'edit'
    end
  end

  scenario 'Unauthenticated user can not edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'edit'
  end
end
