FactoryBot.define do
  sequence :title do |n|
    "Title #{n}"
  end

  factory :question do
    author

    title
    text  { "Text" }

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      after :create do |question|
        question.files.attach(
          io:           File.open(Rails.root.join('spec', 'rails_helper.rb')),
          filename:     'rails_helper.rb',
          content_type: 'text/rb'
        )
      end
    end
  end
end
