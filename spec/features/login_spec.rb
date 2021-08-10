require 'rails_helper'

feature 'User can login', %(
  To ask a question,
  the user must be logged in
) do

  User.create(email: 'someone@mail.to', password: 'qwerty12345')

  background { visit '/login' }

  scenario 'registered user tries to login' do
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    page.should have_content 'Signed in successfully.'
  end

  scenario 'unregistered user tries to login' do
    fill_in 'Email',    with: 'nonexist@mail.to'
    fill_in 'Password', with: 'qwerty12345'
    click_button 'Log in'

    page.should have_content 'Invalid Email or password.'
  end
end
