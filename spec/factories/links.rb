FactoryBot.define do
  sequence :name do |n|
    "Link #{n}"
  end

  factory :link do
    question

    name
    url { 'https://url.to' }
  end
end
