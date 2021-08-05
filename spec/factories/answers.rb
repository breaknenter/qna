FactoryBot.define do
  factory :answer do
    text { "Text" }
    question { nil }

    trait :invalid do
      text { nil }
    end
  end
end
