require 'rails_helper'

feature 'User can create question', %(
  To get a response from the community,
  I, as an authenticated user,
  would like to create a question
) do
  given(:user) { User.create(email: 'someone@mail.to', password: 'qwerty12345') }

  background { visit new_user_session_path }

  scenario 'Authenticated user creates a question' do
    fill_in 'Email',    with: 'someone@mail.to'
    fill_in 'Password', with: 'qwerty12345'
    click_button 'Log in'

    visit questions_path
    click_link 'Ask question'

    fill_in 'Title', 'Test title'
    fill_in 'Text',  'Test text'
    click_link 'Ask'

    expect(page).to have_content 'Your question created.'
    expect(page).to have_content 'Test title'
    expect(page).to have_content 'Test text'
  end

  scenario 'Authenticated user creates a question with errors'
  scenario 'An unauthenticated user is trying to post a question'
end
