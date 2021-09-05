require 'rails_helper'

feature 'The user can delete the file attached to the question' do
  given!(:user)     { create(:user) }
  given!(:question) { create(:question, :with_file, author: user) }
  given!(:filename) { question.files.first.filename.to_s }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'delete his file' do
      within '#question-files' do
        expect(page).to have_link filename

        click_link 'delete'

        expect(page).to_not have_link filename
        expect(page).to_not have_link 'delete'
      end
    end

    context 'user is not author' do
      given!(:user2)          { create(:user) }
      given!(:question2)      { create(:question, :with_file, author: user2) }
      given!(:other_filename) { question2.files.first.filename.to_s }

      before { visit question_path(question2) }

      scenario 'try to delete other file' do
        within '#question-files' do
          expect(page).to     have_link other_filename
          expect(page).to_not have_link 'delete'
        end
      end
    end
  end

  describe 'unauthenticated user' do
    scenario 'try to delete other file' do
      visit question_path(question)

      within '#question-files' do
        expect(page).to_not have_link 'delete'
      end
    end
  end
end
