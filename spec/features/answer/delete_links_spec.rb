require 'rails_helper'

feature 'The author can remove links to his answer' do
  given!(:author)   { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer)   { create(:answer, question: question, author: author) }

  given!(:user)           { create(:user) }
  given!(:other_question) { create(:question, author: user) }
  given!(:other_answer)   { create(:answer, question: other_question, author: user) }

  given!(:link) { { name: 'Link', url: 'https://link.to' } }

  background do
    answer.links.create(link)
    other_answer.links.create(link)
  end

  describe 'Authenticated user', js: true do
    background { sign_in(author) }

    scenario 'the author can remove link' do
      visit question_path(question)

      within('.answer-links') do
        click_link('delete', match: :first)
      end

      expect(page).to have_no_link link[:name], href: link[:url]
    end

    scenario 'not author cant remove link' do
      visit question_path(other_question)

      within('.answer-links') { expect(page).to have_no_link 'delete' }
    end
  end

  scenario 'unauthenticated user cant delete the link' do
    visit question_path(question)

    within('.answer-links') { expect(page).to have_no_link 'delete' }
  end
end
