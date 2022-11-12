require 'rails_helper'

feature 'User can subscribe to new answers to the question' do
  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question, author: author) }

  shared_examples 'unsubscribable' do
    scenario 'can unsubscribe for notifications of new answers', js: true do
      click_button 'Подписаться'

      expect(page).to     have_button 'Отписаться'
      expect(page).to_not have_button 'Подписаться'

      click_button 'Отписаться'

      expect(page).to     have_button 'Подписаться'
      expect(page).to_not have_button 'Отписаться'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'cant subscribe / unsubscribe for notifications of new answers' do
      visit question_path(question)

      expect(page).to_not have_button 'Подписаться'
      expect(page).to_not have_button 'Отписаться'
    end
  end

  describe 'Authenticated user' do
    context 'if he is the author of the question' do
      background do
        sign_in(author)
        visit question_path(question)
      end

      include_examples 'unsubscribable'

      scenario 'has a subscription by default' do
        expect(page).to     have_button 'Отписаться'
        expect(page).to_not have_button 'Подписаться'
      end
    end

    context 'if he is the not author of the question' do
      background do
        sign_in(not_author)
        visit question_path(question)
      end

      include_examples 'unsubscribable'

      scenario 'can subscribe for notifications of new answers', js: true do
        expect(page).to     have_button 'Подписаться'
        expect(page).to_not have_button 'Отписаться'

        click_button 'Подписаться'

        expect(page).to     have_button 'Отписаться'
        expect(page).to_not have_button 'Подписаться'
      end
    end
  end
end
