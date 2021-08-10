require 'rails_helper'

feature 'User can login', %(
  To ask a question,
  the user must be logged in
) do

  User.create(email: 'someone@mail.to', password: 'qwerty12345')

  background { visit new_user_session_path }

  scenario 'registered user tries to login' do
    fill_in 'Email',    with: 'someone@mail.to'
    fill_in 'Password', with: 'qwerty12345'
    click_button 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'unregistered user tries to login' do
    fill_in 'Email',    with: 'nonexist@mail.to'
    fill_in 'Password', with: 'qwerty12345'
    click_button 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end

feature 'User can logout', 'Authenticated user can logout ' do

  User.create(email: 'someone@mail.to', password: 'qwerty12345')

  background { visit new_user_session_path }

  scenario 'Logout' do
    fill_in 'Email',    with: 'someone@mail.to'
    fill_in 'Password', with: 'qwerty12345'
    click_button 'Log in'
    click_link 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
