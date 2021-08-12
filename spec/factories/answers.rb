FactoryBot.define do
  sequence :text do |n|
    "Text text text text #{n}"
  end

  factory :answer do
    text
    question { nil }

    trait :invalid do
      text { nil }
    end
  end
end
