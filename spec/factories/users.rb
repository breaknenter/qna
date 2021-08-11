FactoryBot.define do
  sequence :email do |n|
    "someone#{n}@mail.to"
  end

  factory :user do
    email
    password              { 'qwerty12345' }
    password_confirmation { 'qwerty12345' }
  end
end
