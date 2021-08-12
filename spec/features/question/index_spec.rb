require 'rails_helper'

feature 'User can view the list of questions', %(
  Viewing questions is available
  to registered users and guests
) do
  given!(:question) { create_list(:question, 10) }

  scenario 'view questions' do
    visit questions_path

    1.upto(10) do |n|
      expect(page).to have_content "Question #{n}"
    end
  end
end
