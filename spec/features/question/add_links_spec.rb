require 'rails_helper'

feature 'The user can add links to the question' do
  given!(:user)         { create(:user) }
  given!(:link)         { 'onepagelove' }
  given!(:url)          { 'https://onepagelove.com' }
  given!(:invalid_url)  { 'onepagelove.com' }
  given!(:gist_url)     { 'https://gist.github.com/breaknenter/297fdd1adf66023e67b752ddf96b37d4' }

  context 'authenticated user creating a question' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'with valid link' do
      fill_in 'Title', with: 'Test title'
      fill_in 'Text',  with: 'Test text'

      fill_in 'Link name', with: link
      fill_in 'Url',       with: url

      click_button 'Ask'

      expect(page).to have_link link, href: url
    end

    scenario 'with valid link to gist', js: true do
      fill_in 'Title', with: 'Test title'
      fill_in 'Text',  with: 'Test text'

      fill_in 'Link name', with: 'Gist'
      fill_in 'Url',       with: gist_url

      click_button 'Ask'

      expect(page).to have_link    'test_gist.txt', href: gist_url
      expect(page).to have_content 'What thou lovest well remains, the rest is dross'
    end

    scenario 'with invalid link' do
      fill_in 'Title', with: 'Test title'
      fill_in 'Text',  with: 'Test text'

      fill_in 'Link name', with: link
      fill_in 'Url',       with: invalid_url

      click_button 'Ask'

      expect(page).to have_content 'Invalid URL format'
    end
  end
end
