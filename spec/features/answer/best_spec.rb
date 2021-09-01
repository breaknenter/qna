require 'rails_helper'

feature 'User can choose the best answer' do
  given!(:user)     { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answers)  { create(:answer, question: question, author: user) }

  describe 'authenticated user', js: true do
    background { sign_in(user) }
    background { visit question_path(question) }

    scenario 'chooses the best answer' do
      within '.answers-list' do
        click_link 'set as best'

        expect(page).to_not have_css '.answer'
      end

      expect(page).to have_css '.best-answer'
    end

    context 'is not the author' do
      given!(:user2)     { create(:user) }
      given!(:question2) { create(:question, author: user2) }
      given!(:answers2)  { create_list(:answer, 4, question: question2, author: user2) }

      background { visit question_path(question2) }

      scenario 'trying to choose the best answer' do
        within '.answers-list' do
          expect(page).to_not have_link 'set as best'
        end
      end
    end
  end

  describe 'unauthenticated user', js: true do
    scenario 'trying to choose the best answer' do
      visit question_path(question)

      within '.answers-list' do
        expect(page).to_not have_link 'set as best'
      end
    end
  end
end
