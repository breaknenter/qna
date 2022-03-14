FactoryBot.define do
  factory :vote do
    value { 1 }
    user
    association :voteable, factory: :question
  end
end
