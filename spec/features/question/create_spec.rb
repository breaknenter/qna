require 'rails_helper'

feature 'User can create question', %(
  To get a response from the community,
  I, as an authenticated user,
  would like to create a question
) do
  given(:user) { User.create(email: 'someone@mail.to', password: 'qwerty12345') }

  scenario 'Authenticated user creates a question' do
    visit new_user_session_path
    fill_in 'Email',    with: 'someone@mail.to'
    fill_in 'Password', with: 'qwerty12345'
    click_button 'Log in'

    visit questions_path
    click_link 'Ask question'

    fill_in 'Title', with: 'Test title'
    fill_in 'Text',  with: 'Test text'
    click_button 'Ask'

    expect(page).to have_content 'Your question created.'
    expect(page).to have_content 'Test title'
    expect(page).to have_content 'Test text'
  end

  scenario 'Authenticated user creates a question with errors' do
    visit new_user_session_path
    fill_in 'Email',    with: 'someone@mail.to'
    fill_in 'Password', with: 'qwerty12345'
    click_button 'Log in'

    visit new_question_path
    click_button 'Ask'

    expect(page).to have_content "Title can't be blank"
  end

  scenario 'An unauthenticated user is trying to post a question' do
    visit questions_path
    click_link 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end