FactoryBot.define do
  sequence :title do |n|
    "Title #{n}"
  end

  factory :question do
    title
    text  { "Text" }

    trait :invalid do
      title { nil }
    end
  end
end
