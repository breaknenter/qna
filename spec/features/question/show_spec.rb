require 'rails_helper'

feature 'User can view the question and answers' do
  given(:user)      { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answers)  { create_list(:answer, 4, question: question, author: user) }

  scenario 'show the question and answers' do
    visit question_path(question)

    answers.each do |answer|
      expect(page).to have_content answer.text
    end
  end
end
