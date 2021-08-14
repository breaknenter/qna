require 'rails_helper'

feature 'User can delete his own answer', %(
  The author can delete his own answer or,
  but cannot delete someone else's answer
) do
  given(:author)    { create(:user) }
  given(:user)      { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer)   { create(:answer, question: question, author: author) }

  describe 'author delete answer' do
    before { sign_in(author) }

    scenario 'delete answer' do
      visit question_path(question)
      click_link 'delete answer'

      expect(page).to     have_content 'Your answer delete'
      expect(page).to_not have_content answer.text
    end
  end

  describe 'not author delete answer' do
    before { sign_in(user) }

    scenario 'delete answer' do
      visit question_path(question)

      expect(page).to_not have_link 'delete answer'
    end
  end

  scenario 'unauthenticated user delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'delete answer'
  end
end
