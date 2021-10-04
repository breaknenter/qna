require 'rails_helper'

feature 'The user can add links to the question' do
  given!(:user) { create(:user) }
  given!(:url)  { 'https://onepagelove.com' }

  scenario 'User adds a link when creating a question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test title'
    fill_in 'Text',  with: 'Test text'

    fill_in 'Link name', with: 'onepagelove'
    fill_in 'Url',       with: url

    click_button 'Ask'

    expect(page).to have_link 'onepagelove', href: url
  end
end
