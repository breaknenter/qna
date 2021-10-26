require 'rails_helper'

feature 'The user can add links to the answer' do
  given!(:user)        { create(:user) }
  given!(:question)    { create(:question, author: user) }
  given!(:link)        { 'onepagelove' }
  given!(:url)         { 'https://onepagelove.com' }
  given!(:invalid_url) { 'onepagelove.com' }
  given!(:gist_url)    { 'https://gist.github.com/breaknenter/297fdd1adf66023e67b752ddf96b37d4' }

  context 'authenticated user creating a answer', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid link' do
      within '.answer-create' do
        fill_in 'Text', with: 'Answer text'

        fill_in 'Link name', with: link
        fill_in 'Url',       with: url

        click_button 'Answer'
      end

      within '.answers-list' do
        expect(page).to have_link link, href: url
      end
    end

    scenario 'with valid link to gist' do
      within '.answer-create' do
        fill_in 'Text', with: 'Answer text'

        fill_in 'Link name', with: 'Gist'
        fill_in 'Url',       with: gist_url

        click_button 'Answer'
      end

      within '.answers-list' do
        expect(page).to have_link    'test_gist.txt', href: gist_url
        expect(page).to have_content 'What thou lovest well remains, the rest is dross'
      end
    end

    scenario 'with invalid link' do
      within '.answer-create' do
        fill_in 'Text', with: 'Answer text'

        fill_in 'Link name', with: ''
        fill_in 'Url',       with: invalid_url

        click_button 'Answer'
      end

      within '.answer-errors' do
        expect(page).to have_content "name can't be blank"
        expect(page).to have_content 'Invalid URL format'
      end
    end
  end
end
