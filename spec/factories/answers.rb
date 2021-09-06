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

    trait :with_file do
      after :create do |answer|
        answer.files.attach(
          io:           File.open(Rails.root.join('spec', 'rails_helper.rb')),
          filename:     'rails_helper.rb',
          content_type: 'text/rb'
        )
      end
    end
  end
end
