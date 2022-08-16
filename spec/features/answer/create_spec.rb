require 'rails_helper'

feature 'The user, being on the question page, can write an answer' do
  given(:user)      { create(:user)  }
  given(:guest)     { create(:guest) }
  given!(:question) { create(:question, author: user) }

  describe 'authenticated user creates a answer', js: true do
    background { sign_in(user) }
    background { visit question_path question }

    scenario 'create valid answer' do
      within '.answer-create' do
        fill_in 'Text', with: 'Answer text'
        click_button 'Answer'
      end

      expect(page).to have_content 'Answer text'
    end

    scenario 'create answer with files' do
      within '.answer-create' do
        fill_in 'Text', with: 'Answer text'
        attach_file 'File', Rails.root.join('spec/rails_helper.rb')
        click_button 'Answer'
      end

      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'create invalid answer' do
      click_button 'Answer'

      expect(page).to have_content "Text can't be blank"
    end
  end

  describe 'unauthenticated user creates a answer', js: true do
    scenario 'tries to answer a question' do
      visit question_path question

      expect(page).not_to have_button 'Answer'
    end
  end

  scenario 'Answer appears on another user page', js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path question

      within '.answer-create' do
        fill_in 'Text', with: 'Answer text'
      end
    end

    Capybara.using_session('guest') do
      visit question_path question
    end

    Capybara.using_session('user') do
      within '.answer-create' do
        click_button 'Answer'
      end

      expect(page).to have_content 'Answer text'
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'Answer text'
    end
  end
end
