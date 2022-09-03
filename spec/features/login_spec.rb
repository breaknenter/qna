require 'rails_helper'

feature 'User can register', 'User registration for full functionality ' do
  background { visit new_user_registration_path }

  scenario 'Registration with valid data and confirmation email' do
    fill_in 'Email',                 with: 'joeshmoe@mail.to'
    fill_in 'Password',              with: 'qwerty12345'
    fill_in 'Password confirmation', with: 'qwerty12345'
    click_button 'Sign up'

    open_email('joeshmoe@mail.to')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  scenario 'Registration with invalid data' do
    fill_in 'Email',    with: 'joeshmoe@mail.to'
    fill_in 'Password', with: 'qwerty12345'
    click_button 'Sign up'

    expect(page).to have_css('.alert')
  end
end

feature 'User can login', %(
  To ask a question,
  the user must be logged in
) do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'registered user tries to login' do
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
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
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Logout' do
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    click_link 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
