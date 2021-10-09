require 'rails_helper'

feature 'User can edit his question' do
  given!(:user)     { create(:user) }
  given!(:question) { create(:question, author: user) }

  given!(:user2)     { create(:user) }
  given!(:question2) { create(:question, author: user2) }

  given!(:link) { { name: 'Link', url: 'https://link.to' } }

  background do
    question.links.create(link)
  end

  describe 'Authenticated user', js: true do
    before { sign_in(user) }

    scenario 'edit his question' do
      visit question_path(question)

      within '.question' do
        click_link 'edit'
        fill_in 'Title', with: 'Edited title'
        fill_in 'Text',  with: 'Edited text'
        click_button 'save'

        expect(page).not_to have_content  question.title
        expect(page).not_to have_content  question.text
        expect(page).to     have_content  'Edited title'
        expect(page).to     have_content  'Edited text'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'edit his question with errors' do
      visit question_path(question)

      within '.question' do
        click_link 'edit'
        fill_in 'Title', with: 'Edited title'
        fill_in 'Text',  with: ''
        click_button 'save'

        expect(page).to have_content "Text can't be blank"
      end
    end

    scenario 'edit his question and attach new file' do
      visit question_path(question)

      within('.question') do
        click_link 'edit'
        fill_in 'Title', with: 'Edited title'
        fill_in 'Text',  with: 'Edited text'
        attach_file 'File', Rails.root.join('spec/rails_helper.rb')
        click_button 'save'

        expect(page).not_to have_content  question.title
        expect(page).not_to have_content  question.text
        expect(page).to     have_content  'Edited title'
        expect(page).to     have_content  'Edited text'
        expect(page).not_to have_selector 'textarea'
        expect(page).to     have_link     'rails_helper.rb'
      end
    end

    scenario 'edit link' do
      visit question_path(question)
      click_link 'edit'

      within '.nested-fields:first-of-type' do
        fill_in 'Link name', with: 'Edited link'
        fill_in 'Url',       with: 'https://editedlink.to'
      end

      click_button 'save'

      expect(page).to have_link 'Edited link', href: 'https://editedlink.to'
    end

    scenario 'try to edit other user question' do
      visit question_path(question2)

      expect(page).to_not have_link 'edit'
    end
  end

  scenario 'Unauthenticated user can not edit question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'edit'
  end
end
