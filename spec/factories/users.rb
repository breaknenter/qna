FactoryBot.define do
  sequence :email do |n|
    "someone#{n}@mail.to"
  end

  factory :user, aliases: [:author] do
    email
    password              { 'qwerty12345' }
    password_confirmation { 'qwerty12345' }
    confirmed_at          { Time.zone.now }
  end
end
