require 'rails_helper'

feature 'The author can remove links to his question' do
  given!(:author)   { create(:user) }
  given!(:user)     { create(:user) }
  given!(:question) { create(:question, author: author) }

  given!(:link1) { { name: 'Link 1', url: 'https://link1.to' } }
  given!(:link2) { { name: 'Link 2', url: 'https://link2.to' } }

  background do
    question.links.create([link1, link2])
  end

  scenario 'the author removes link in his question', js: true do
    sign_in(author)
    visit question_path(question)

    within('.links') do
      click_link('delete', match: :first)
    end

    expect(page).to_not have_link link1[:name], href: link1[:url]
    expect(page).to     have_link link2[:name], href: link2[:url]
  end

  context 'not the author is trying to delete the link' do
    scenario 'authenticated user', js: true do
      sign_in(user)
      visit question_path(question)

      within('.links') { expect(page).to_not have_link 'delete' }
    end

    scenario 'quest', js: true do
      visit question_path(question)

      within('.links') { expect(page).to_not have_link 'delete' }
    end
  end
end
