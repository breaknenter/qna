require 'rails_helper'

feature 'User can edit his answer' do
  given!(:user)     { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer)   { create(:answer, question: question, author: user) }

  given!(:user2)     { create(:user) }
  given!(:question2) { create(:question, author: user2) }
  given!(:answer2)   { create(:answer, question: question2, author: user2) }

  given!(:link) { { name: 'Link', url: 'https://link.to' } }

  background do
    answer.links.create(link)
  end

  describe 'Authenticated user', js: true do
    before { sign_in(user) }

    scenario 'edit his answer' do
      visit question_path(question)

      within('.answers-list') do
        click_link 'edit'
        fill_in 'Text', with: 'Edited answer'
        click_button 'save'

        expect(page).to_not have_content  answer.text
        expect(page).to     have_content  'Edited answer'
        expect(page).to_not have_selector '#answer_text'
      end
    end

    scenario 'edit his answer with errors' do
      visit question_path(question)

      within('.answers-list') do
        click_link 'edit'
        fill_in 'Text', with: ''
        click_button 'save'
      end

      expect(page).to have_content  "Text can't be blank"
    end

    scenario 'edit his answer and attach file' do
      visit question_path(question)

      within('.answers-list') do
        click_link 'edit'
        fill_in 'Text', with: 'Edited answer'
        attach_file 'File', Rails.root.join('spec/rails_helper.rb')
        click_button 'save'

        expect(page).to_not have_content  answer.text
        expect(page).to     have_content  'Edited answer'
        expect(page).to_not have_selector '#answer_text'
        expect(page).to     have_link     'rails_helper.rb'
      end
    end

    scenario 'edit his answer and change link' do
      visit question_path(question)

      within('.answers-list') do
        click_link 'edit'

        within('.nested-fields:first-of-type') do
          fill_in 'Link name', with: 'Changed link'
          fill_in 'Url',       with: 'https://changedlink.to'
        end

        click_button 'save'

        expect(page).to have_link 'Changed link', href: 'https://changedlink.to'
      end
    end

    scenario 'edit his answer and add new link' do
      visit question_path(question)

      within('.answers-list') do
        click_link 'edit'

        within('.nested-fields:last-of-type') do
          fill_in 'Link name', with: 'Added link'
          fill_in 'Url',       with: 'https://addedlink.to'
        end

        click_button 'save'

        expect(page).to have_link 'Added link', href: 'https://addedlink.to'
      end
    end

    scenario 'try to edit other user answer' do
      visit question_path(question2)

      expect(page).to_not have_link 'edit'
    end
  end

  scenario 'Unauthenticated user can not edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'edit'
  end
end
