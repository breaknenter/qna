require 'rails_helper'

feature 'The user can add comment to the answer' do
  given!(:author)   { create(:user) }
  given!(:user)     { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer)   { create(:answer, question: question, author: author) }

  context 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add comment' do
      within('.answers-list') do
        fill_in 'comment_text', with: 'Comment text'
        click_button 'Comment'
      end

      expect(page).to have_content 'Comment text'
    end
  end

  context 'Unauthenticated user', js: true do
    background { visit question_path(question) }

    scenario 'try add comment' do
      expect(page).not_to have_selector '.answers-list #comment-form'
    end
  end

  scenario 'Comment appears on another user page', js: true do
    Capybara.using_session('author') do
      sign_in(author)
      visit question_path(question)

      within('.answers-list') do
        fill_in 'comment_text', with: 'Comment text'
      end
    end

    Capybara.using_session('user') do
      visit question_path(question)
    end

    Capybara.using_session('author') do
      within('.answers-list') do
        click_button 'Comment'
      end
    end

    Capybara.using_session('user') do
      expect(page).to have_content 'Comment text'
    end
  end
end
