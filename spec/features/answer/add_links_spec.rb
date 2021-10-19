require 'rails_helper'

feature 'The user can add links to the answer' do
  given!(:user)        { create(:user) }
  given!(:question)    { create(:question, author: user) }
  given!(:link)        { 'onepagelove' }
  given!(:url)         { 'https://onepagelove.com' }
  given!(:invalid_url) { 'onepagelove.com' }

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

    scenario 'with invalid link' do
    end
  end
end
