require 'rails_helper'

feature 'User can create question', %(
  To get a response from the community,
  I, as an authenticated user,
  would like to create a question
) do

  given(:user)  { create(:user)  }
  given(:guest) { create(:guest) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: 'Test title'
      fill_in 'Text',  with: 'Test text'
    end

    scenario 'creates a question' do
      click_button 'Ask'

      expect(page).to have_content 'Your question created.'
      expect(page).to have_content 'Test title'
      expect(page).to have_content 'Test text'
    end

    scenario 'creates a question with files' do
      attach_file 'File', [Rails.root.join('spec/rails_helper.rb'),
                           Rails.root.join('spec/spec_helper.rb')]
      click_button 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'creates a question with link' do
      fill_in 'Link name', with: 'onepagelove'
      fill_in 'Url',       with: 'https://onepagelove.com'

      click_button 'Ask'

      expect(page).to have_link 'onepagelove', href: 'https://onepagelove.com'
    end

    scenario 'creates a question with reward' do
      fill_in 'Reward', with: 'Reward name'
      attach_file 'Image', Rails.root.join('spec/files/reward.jpg')

      click_button 'Ask'

      expect(page).to have_css("img[src*='reward.jpg']")
      expect(page).to have_content 'Reward name'
    end

    scenario 'creates a question with errors' do
      visit new_question_path
      click_button 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'An unauthenticated user is trying to post a question' do
    visit questions_path
    click_link 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Question appears on another user page', js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: 'Test title'
      fill_in 'Text',  with: 'Test text'
    end

    Capybara.using_session('guest') do
      visit questions_path
    end

    Capybara.using_session('user') do
      click_button 'Ask'
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'Test title'
    end
  end
end
