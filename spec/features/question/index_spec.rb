require 'rails_helper'

feature 'User can view the list of questions', %(
  Viewing questions is available
  to registered users and guests
) do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 10, author: user) }

  scenario 'view questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
