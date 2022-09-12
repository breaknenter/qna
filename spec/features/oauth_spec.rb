require 'rails_helper'

feature 'Authentication with OAuth providers' do
  given!(:user) { create(:user, email: 'joeshmoe@mail.to') }

  background { visit new_user_session_path }

  describe 'Github' do
    given(:oauth_with_exist_email) do
      OmniAuth.config.mock_auth[:github] =
        OmniAuth::AuthHash.new(
          provider: 'github',
          uid: '1234',
          info: { email: 'joeshmoe@mail.to' }
        )
    end

    given(:oauth_with_not_exist_email) do
      OmniAuth.config.mock_auth[:github] =
        OmniAuth::AuthHash.new(
          provider: 'github',
          uid: '1234',
          info: { email: nil }
        )
    end

    scenario 'sign in with exist email' do
      oauth_with_exist_email
      click_link 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    scenario 'sign in with not exist email' do
      oauth_with_not_exist_email
      click_link 'Sign in with GitHub'

      expect(page).to have_content 'Введите email'

      fill_in 'Email', with: 'nonexist@mail.to'
      click_button 'Отправить'

      open_email('nonexist@mail.to')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end

  describe 'VK' do
    background do
      OmniAuth.config.mock_auth[:vkontakte] =
        OmniAuth::AuthHash.new(
          provider: 'github',
          uid: '1234',
          info: { email: nil }
        )
    end

    scenario 'sign in with exist email' do
      click_link 'Sign in with Vkontakte'

      expect(page).to have_content 'Введите email'

      fill_in 'Email', with: 'joeshmoe@mail.to'
      click_button 'Отправить'

      expect(page).to have_current_path(root_path)
    end

    scenario 'sign in with not exist email' do
      click_link 'Sign in with Vkontakte'

      expect(page).to have_content 'Введите email'

      fill_in 'Email', with: 'nonexist@mail.to'
      click_button 'Отправить'

      open_email('nonexist@mail.to')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end
end
