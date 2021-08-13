require 'rails_helper'

feature 'User can delete his own question or answer', %(
  The author can delete his own question or,
  but cannot delete someone else's question / answer
) do
  given(:author)    { create(:user) }
  given(:user)      { create(:user) }
  given!(:question) { create(:question, author: author) }

  describe 'Authenticated user delete question' do
    scenario 'author delete his question' do
      background { sign_in(author) }

      visit question_path(question)
      click_link 'delete'

      expect(page).to     have_content 'Your question delete'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.text
    end

    scenario 'not author delete author question' do
      background { sign_in(user) }

      visit question_path(question)

      expect(page).to_not have_link 'delete'
    end
  end

  scenario 'unauthenticated user delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'delete'
  end
end
