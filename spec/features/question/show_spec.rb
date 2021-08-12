require 'rails_helper'

feature 'User can view the question and answers' do
  given!(:question) { create(:question) }
  given!(:answers)  { create_list(:answer, 4, question: question) }

  scenario 'show the question and answers' do
    visit question_path(question)

    answers.each do |answer|
      expect(page).to have_content "#{answer.text}"
    end
  end
end
