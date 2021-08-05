FactoryBot.define do
  factory :question do
    title { "Title" }
    text  { "Text" }

    trait :invalid do
      title { nil }
    end
  end
end
