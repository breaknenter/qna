require 'rails_helper'

feature 'User can see their rewards' do
  given(:user)   { create(:user) }
  given(:reward) { create(:reward, user: user) }

  scenario 'Authenticated user views rewards' do
    sign_in(user)
    visit rewards_path

    expect(page).to have_content 'Rewards:'
    expect(page).to have_link reward.question.title, href: "/questions/#{reward.question.id}"
    expect(page).to have_content reward.name
    expect(page).to have_css("img[src*='reward.jpg']")
  end
end
