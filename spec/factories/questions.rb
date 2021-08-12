FactoryBot.define do
  sequence :title do |n|
    "Question #{n}"
  end

  factory :question do
    title
    text  { 'Text text text' }

    trait :invalid do
      title { nil }
    end
  end
end
