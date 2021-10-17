FactoryBot.define do
  sequence :name do |n|
    "Link #{n}"
  end

  factory :link do
    association :linkable, factory: :question

    name
    url { 'https://url.to' }
  end
end
