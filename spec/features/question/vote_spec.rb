require 'rails_helper'

feature 'User can vote for a question' do
  given!(:user) { create :user }
  given!(:author) { create :user }
  given!(:question) { create :question, author: author }

  context 'authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees counter and links and set like' do
      within('.votes') do
        expect(page).to have_content '0'
        expect(page).to have_link '+'
        expect(page).to have_link '-'

        click_link '+'

        expect(page).to have_content '1'
      end
    end
  end
end
