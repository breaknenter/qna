require 'rails_helper'

feature 'User can delete his own question', %(
  The author can delete his own question or,
  but cannot delete someone else's question
) do
  given(:author)    { create(:user) }
  given(:user)      { create(:user) }
  given!(:question) { create(:question, author: author) }

  describe 'author delete question' do
    before { sign_in(author) }

    scenario 'delete question' do
      visit question_path(question)
      click_link 'delete'

      expect(page).to     have_content 'Your question delete'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.text
    end
  end

  describe 'not author delete question' do
    before { sign_in(user) }

    scenario 'delete question' do
      visit question_path(question)

      expect(page).to_not have_link 'delete'
    end
  end

  scenario 'unauthenticated user delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'delete'
  end
end
